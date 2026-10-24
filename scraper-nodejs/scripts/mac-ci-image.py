#!/usr/bin/env python3
"""Build a clean published commit on the Mac; verify an immutable SSH image load.

No registry publishing and no remote build fallback. Split phases share the
worker's private SASID_CI_ARTIFACT_DIR. Application backup/migrate/health/rollback
remain in the application's release script, under the same VPS release lock.
"""
from __future__ import annotations

import argparse
import contextlib
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import signal
import subprocess
import sys
import tarfile
import tempfile
import time
import uuid

STOP = 0
FLOOR = 50 * 1024 ** 3
SHA = re.compile(r'[a-f0-9]{40}')
DIGEST = re.compile(r'sha256:[a-f0-9]{64}')
SSH_OPTIONS = ['-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=15', '-o', 'ServerAliveInterval=30']
VPS_LOCK = '/opt/platform/.hackathon-rollout.lock'


class ImageError(Exception):
    pass


class Deferred(ImageError):
    pass


def private_dir(path):
    if path.is_symlink():
        raise ImageError('Private artifact directory must not be a symlink')
    path.mkdir(parents=True, exist_ok=True, mode=0o700)
    path.chmod(0o700)
    return path


def disk_ready(path):
    volume = Path('/System/Volumes/Data') if sys.platform == 'darwin' else path
    if shutil.disk_usage(volume).free < FLOOR:
        raise Deferred('Mac image I/O requires at least50GiB free; no VPS build fallback')


def terminate(child):
    with contextlib.suppress(ProcessLookupError):
        os.killpg(child.pid, signal.SIGTERM)
    try:
        child.wait(timeout=5)
    except subprocess.TimeoutExpired:
        pass
    with contextlib.suppress(ProcessLookupError):
        os.killpg(child.pid, signal.SIGKILL)
    child.wait()


def lease_fds():
    value = os.environ.get('SASID_CI_LEASE_FDS', '')
    if not value:
        return ()
    if not re.fullmatch(r'[0-9]+(?:,[0-9]+)*', value):
        raise ImageError('Invalid inherited worker lease list')
    result = tuple(dict.fromkeys(int(item) for item in value.split(',')))
    for fd in result:
        if fd < 3:
            raise ImageError('Invalid inherited worker lease descriptor')
        os.fstat(fd)
    return result


def run(argv, *, cwd=None, input=None, timeout=60, image_io=False):
    if image_io:
        disk_ready(Path(cwd or Path.cwd()))
    env = {key: os.environ[key] for key in ('HOME', 'PATH', 'LANG', 'SSH_AUTH_SOCK', 'BUILDX_BUILDER', 'SASID_CI_LEASE_FDS') if key in os.environ}
    env.update(GIT_TERMINAL_PROMPT='0', GIT_SSH_COMMAND='ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=15')
    # Worker lease FDs arrive inheritable. Preserve them through our own children
    # so killing this helper cannot release a live build's admission lease.
    child = subprocess.Popen(argv, cwd=cwd, env=env, stdin=subprocess.PIPE if input is not None else subprocess.DEVNULL,
      stdout=subprocess.PIPE, stderr=None, text=True, start_new_session=True, pass_fds=lease_fds(), umask=0o022)
    deadline = time.monotonic() + timeout
    next_disk = 0
    try:
        while True:
            if STOP:
                raise ImageError('Owned image command interrupted')
            if time.monotonic() > deadline:
                raise ImageError('Owned image command timed out')
            if image_io and time.monotonic() >= next_disk:
                disk_ready(Path(cwd or Path.cwd()))
                next_disk = time.monotonic() + 1
            try:
                output, _ = child.communicate(input=input, timeout=.2)
                break
            except subprocess.TimeoutExpired:
                input = None
        if child.returncode == 75:
            raise Deferred('Image command deferred before application mutation')
        if child.returncode:
            raise ImageError(Path(argv[0]).name + ' command failed')
        if len(output) > 2_000_000:
            raise ImageError('Image tool output exceeded its limit')
        return output.strip()
    finally:
        terminate(child)
        child.stdout.close()
        if child.stdin:
            child.stdin.close()


def git(source, *args):
    return run(['git', '-c', 'core.hooksPath=/dev/null', '-C', str(source), *args])


def source_identity(source, test_local=False):
    source = source.resolve()
    sha = git(source, 'rev-parse', '--verify', 'HEAD^{commit}')
    branch = git(source, 'symbolic-ref', '--short', 'HEAD')
    if not SHA.fullmatch(sha) or branch not in ('main', 'master') or git(source, 'status', '--porcelain'):
        raise ImageError('Image source must be a clean main or master commit')
    origin = git(source, 'remote', 'get-url', 'origin')
    if not test_local and not re.fullmatch(r'(?:git@github\.com:|https://github\.com/)(?:D10100111001/[A-Za-z0-9_.-]+|ArrahmaMobile/arrahma_mobile)(?:\.git)?', origin, re.I):
        raise ImageError('Image source origin is outside the owner allowlist')
    tip = git(source, 'ls-remote', '--exit-code', '--refs', 'origin', 'refs/heads/' + branch)
    if tip != sha + '\trefs/heads/' + branch:
        raise ImageError('Image source must equal the exact published default-branch tip')
    return sha


def docker(*args, **kwargs):
    socket = 'unix://' + str(Path.home() / '.docker/run/docker.sock')
    return run(['docker', '--host', socket, *args], **kwargs)


def local_builder():
    builder = os.environ.get('BUILDX_BUILDER', 'sasid-ci')
    if builder != 'sasid-ci':
        raise ImageError('The reviewed local sasid-ci builder is required')
    record = docker('buildx', 'inspect', builder)
    endpoints = re.findall(r'^Endpoint:\s+(\S+)\s*$', record, re.M)
    local = {'default', 'desktop-linux', 'unix:///var/run/docker.sock', 'unix://' + str(Path.home() / '.docker/run/docker.sock')}
    if not endpoints or any(endpoint not in local for endpoint in endpoints):
        raise ImageError('BuildKit endpoints must use the local Mac Docker daemon')
    for endpoint in endpoints:
        if not endpoint.startswith('unix://'):
            contexts = json.loads(docker('context', 'inspect', endpoint))
            if len(contexts) != 1 or contexts[0].get('Endpoints', {}).get('docker', {}).get('Host') not in local:
                raise ImageError('BuildKit context does not resolve to the local Mac socket')
    return builder


def digest_file(path):
    result = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(chunk)
    return result.hexdigest()


def image_record(tag, commit):
    rows = json.loads(docker('image', 'inspect', tag))
    image = rows[0]
    layers = image.get('RootFS', {}).get('Layers')
    if (image.get('Os') != 'linux' or image.get('Architecture') != 'amd64' or
        image.get('Config', {}).get('Labels', {}).get('org.opencontainers.image.revision') != commit or
        not DIGEST.fullmatch(image.get('Id', '')) or not isinstance(layers, list) or
        not all(isinstance(layer, str) and DIGEST.fullmatch(layer) for layer in layers)):
        raise ImageError('Image architecture, revision, ID or RootFS verification failed')
    return {'imageId': image['Id'], 'rootfsLayers': layers, 'os': 'linux', 'architecture': 'amd64'}


def archive_identity(archive, tag, commit, observed):
    """Docker save's config digest is portable across Desktop/classic stores."""
    with tarfile.open(archive) as stream:
        def small_json(name):
            path = Path(name)
            if path.is_absolute() or '..' in path.parts:
                raise ImageError('Unsafe image archive metadata path')
            member = stream.getmember(name)
            if not member.isfile() or member.size > 4 * 1024 * 1024:
                raise ImageError('Unsafe image archive metadata')
            content = stream.extractfile(member).read()
            return json.loads(content), content
        entries, _ = small_json('manifest.json')
        candidates = [entry for entry in entries if tag in (entry.get('RepoTags') or [])]
        if len(candidates) != 1:
            raise ImageError('Saved image does not identify exactly one immutable tag')
        config, content = small_json(candidates[0]['Config'])
        if (config.get('os') != 'linux' or config.get('architecture') != 'amd64' or
            config.get('config', {}).get('Labels', {}).get('org.opencontainers.image.revision') != commit or
            config.get('rootfs', {}).get('diff_ids') != observed['rootfsLayers']):
            raise ImageError('Saved image config does not match the inspected build')
        return dict(observed, localImageId=observed['imageId'], imageId='sha256:' + hashlib.sha256(content).hexdigest())


def manifest_asset(source, context, specification):
    try:
        name, manifest_name = specification.split('=', 1)
    except ValueError:
        raise ImageError('Manifest asset must name asset=committed-manifest')
    relative, manifest_relative = Path(name), Path(manifest_name)
    if (relative.is_absolute() or manifest_relative.is_absolute() or '..' in relative.parts or '..' in manifest_relative.parts or
        relative.suffix != '.blend' or relative.parent != manifest_relative.parent):
        raise ImageError('Only an explicitly manifest-bound Blender asset is supported')
    asset, manifest = source / relative, context / manifest_relative
    if not asset.is_file() or asset.is_symlink() or not manifest.is_file() or manifest.is_symlink():
        raise ImageError('Manifest-bound Blender asset is missing or unsafe')
    entries = json.loads(manifest.read_text()).get('artifacts', [])
    matches = [entry for entry in entries if entry.get('path') == relative.name]
    if len(matches) != 1 or not re.fullmatch(r'[a-f0-9]{64}', matches[0].get('sha256', '')) or digest_file(asset) != matches[0]['sha256']:
        raise ImageError('Blender asset does not match its committed manifest')
    destination = context / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(asset, destination)
    destination.chmod(0o644)
    return matches[0]['sha256']


def build(source, tag, commit, directory, args):
    disk_ready(directory)
    builder = local_builder()
    with tempfile.TemporaryDirectory(prefix='context-', dir=directory) as temporary:
        root = Path(temporary)
        archive = root / 'source.tar'
        git(source, 'archive', '--format=tar', '--output=' + str(archive), commit)
        snapshot = root / 'source'
        snapshot.mkdir(mode=0o700)
        with tarfile.open(archive) as stream:
            stream.extractall(snapshot, filter='data')
        archive.unlink()
        assets = {asset: manifest_asset(source, snapshot, asset) for asset in args.manifest_asset}
        relative = Path(args.context)
        if relative.is_absolute() or '..' in relative.parts:
            raise ImageError('Build context must be a committed relative directory')
        context = snapshot
        for part in relative.parts:
            context = context / part
            if context.is_symlink():
                raise ImageError('Build context must not traverse a symlink')
        if not context.is_dir() or not context.resolve().is_relative_to(snapshot.resolve()):
            raise ImageError('Build context must be a committed relative directory')
        dockerfile = Path(args.dockerfile)
        if dockerfile.is_absolute() or '..' in dockerfile.parts or not (context / dockerfile).is_file():
            raise ImageError('Dockerfile must belong to the committed build context')
        command = ['buildx', 'build', '--builder', builder, '--platform', 'linux/amd64', '--load',
          '--label', 'org.opencontainers.image.revision=' + commit, '--tag', tag, '--file', str(context / dockerfile)]
        if args.pull:
            command.append('--pull')
        for argument in args.build_arg:
            key, separator, value = argument.partition('=')
            if not separator or key not in {'RELEASE_SHA', 'APP_VERSION', 'SOURCE_REVISION', 'VITE_RELEASE_SHA', 'VITE_BUILD_ID', 'BLEND_SHA256'}:
                raise ImageError('Build argument is not a reviewed public release value')
            if value != commit and value not in assets.values():
                raise ImageError('Release build arguments must match the source or manifest asset')
            command += ['--build-arg', argument]
        command.append(str(context))
        # Build stdout is progress, never the handoff JSON.
        progress = docker(*command, timeout=7200, image_io=True)
        if progress:
            print(progress, file=sys.stderr)
        record = image_record(tag, commit)
        archive = directory / 'image.tar'
        if archive.is_symlink():
            raise ImageError('Image archive must not be a symlink')
        docker('image', 'save', '--output', str(archive), tag, timeout=900, image_io=True)
        archive.chmod(0o600)
        if image_record(tag, commit) != record:
            raise ImageError('Image tag changed while exporting its archive')
        canonical = archive_identity(archive, tag, commit, record)
        manifest = dict(canonical, schemaVersion=1, commit=commit, imageTag=tag, archiveSha256=digest_file(archive),
          archiveBytes=archive.stat().st_size, transport='ssh-image-archive', loaded=False, assets=assets)
        target = directory / 'image.json'
        if target.is_symlink():
            raise ImageError('Image manifest must not be a symlink')
        target.write_text(json.dumps(manifest, indent=2) + '\n')
        target.chmod(0o600)
        return manifest


ADMISSION = r'''import subprocess,sys
try:
 available=next(int(line.split()[1]) for line in open('/proc/meminfo') if line.startswith('MemAvailable:'))
 result=subprocess.run(['docker','exec','platform-postgres-1','psql','-U','postgres','-d','postgres','-Atqc','select count(*) from pg_stat_activity;'],capture_output=True,text=True,check=True,timeout=15)
 connections=int(result.stdout.strip())
 if connections<0 or connections>=80 or available<1572864: raise ValueError()
except Exception:
 print('VPS release deferred: freshPG<80 and MemAvailable>=1.5GiB required',file=sys.stderr);sys.exit(75)
'''

REMOTE = r'''set -euo pipefail
umask 077
stage=$1 image=$2 commit=$3
exec 8>/opt/platform/.hackathon-rollout.lock
flock -n -E 75 8 || exit 75
python3 - <<'SASID_ADMISSION'
''' + ADMISSION + r'''
SASID_ADMISSION
python3 - "$stage" "$image" "$commit" <<'SASID_ARCHIVE'
import hashlib,json,pathlib,re,sys
p=pathlib.Path(sys.argv[1]); m=json.loads((p/'image.json').read_text())
assert m['schemaVersion']==1 and m['commit']==sys.argv[3] and m['imageTag']==sys.argv[2]
assert m['os']=='linux' and m['architecture']=='amd64' and re.fullmatch(r'sha256:[a-f0-9]{64}',m['imageId'])
h=hashlib.sha256()
with (p/'image.tar').open('rb') as f:
 for b in iter(lambda:f.read(1048576),b''):h.update(b)
assert h.hexdigest()==m['archiveSha256'] and (p/'image.tar').stat().st_size==m['archiveBytes']
SASID_ARCHIVE
docker image load --input "$stage/image.tar" >/dev/null
python3 - "$stage/image.json" "$image" <<'SASID_IMAGE'
import json,subprocess,sys
m=json.load(open(sys.argv[1])); i=json.loads(subprocess.check_output(['docker','image','inspect',sys.argv[2]],text=True))[0]
assert i['Id']==m['imageId'] and i['Os']==m['os'] and i['Architecture']==m['architecture']
assert i['RootFS']['Layers']==m['rootfsLayers']
assert i['Config']['Labels']['org.opencontainers.image.revision']==m['commit']
print(json.dumps({'loaded':True,'imageId':i['Id'],'commit':m['commit']}))
SASID_IMAGE
'''


def transfer(directory, tag, commit, host):
    manifest_path, archive = directory / 'image.json', directory / 'image.tar'
    if any(path.is_symlink() or not path.is_file() for path in (manifest_path, archive)):
        raise ImageError('Split image handoff is missing or unsafe')
    manifest = json.loads(manifest_path.read_text())
    if (manifest.get('schemaVersion') != 1 or manifest.get('commit') != commit or manifest.get('imageTag') != tag or
        digest_file(archive) != manifest.get('archiveSha256') or archive.stat().st_size != manifest.get('archiveBytes')):
        raise ImageError('Split image handoff identity or archive checksum failed')
    stage = run(['ssh', *SSH_OPTIONS, host, 'umask 077; mktemp -d /tmp/sasid-image-' + commit[:12] + '.XXXXXXXX'])
    if not re.fullmatch(r'/tmp/sasid-image-' + commit[:12] + r'\.[A-Za-z0-9]{8}', stage):
        raise ImageError('Remote private image stage was not created safely')
    try:
        run(['scp', *SSH_OPTIONS, '-q', str(archive), str(manifest_path), host + ':' + stage + '/'], timeout=900)
        result = json.loads(run(['ssh', *SSH_OPTIONS, host, 'bash -s -- ' + ' '.join(shlex.quote(item) for item in (stage, tag, commit))], input=REMOTE, timeout=900))
        if result != {'loaded': True, 'imageId': manifest['imageId'], 'commit': commit}:
            raise ImageError('Remote image load did not return its exact identity')
        return dict(manifest, loaded=True)
    finally:
        with contextlib.suppress(ImageError, OSError):
            run(['ssh', *SSH_OPTIONS, host, 'rm -rf -- ' + shlex.quote(stage)], timeout=30)


def stop(signum, _frame):
    global STOP
    STOP = signum


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', type=Path, default=Path.cwd())
    parser.add_argument('--image', required=True)
    parser.add_argument('--host')
    parser.add_argument('--dockerfile', default='Dockerfile')
    parser.add_argument('--context', default='.', help='Committed repository-relative build context directory')
    parser.add_argument('--build-arg', action='append', default=[])
    parser.add_argument('--pull', action='store_true', help='Refresh base image tags on the local builder')
    parser.add_argument('--manifest-asset', action='append', default=[])
    phase = parser.add_mutually_exclusive_group()
    phase.add_argument('--build-only', action='store_true')
    phase.add_argument('--transfer-only', action='store_true')
    parser.add_argument('--test-local-remotes', action='store_true', help=argparse.SUPPRESS)
    args = parser.parse_args(argv)
    os.umask(0o077)
    if sys.platform != 'darwin' and not args.test_local_remotes:
        raise ImageError('Image builds run on the reviewed Mac worker')
    if not re.fullmatch(r'[a-z0-9][a-z0-9._:/-]*:[a-f0-9]{12,40}', args.image):
        raise ImageError('Image tag must carry an immutable commit identity')
    if not args.build_only and (not args.host or not re.fullmatch(r'[A-Za-z0-9._-]+@[A-Za-z0-9.-]+', args.host)):
        raise ImageError('Verified SSH image transfer requires an explicit user@host')
    persistent = os.environ.get('SASID_CI_ARTIFACT_DIR')
    if (args.build_only or args.transfer_only) and not persistent:
        raise ImageError('Split phases require the owned SASID_CI_ARTIFACT_DIR')
    commit = source_identity(args.source, args.test_local_remotes)
    if args.image.rsplit(':', 1)[1] not in (commit, commit[:12]):
        raise ImageError('Image tag does not match the exact source SHA')
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    with contextlib.ExitStack() as stack:
        if persistent:
            base = Path(persistent)
            if not base.is_absolute():
                raise ImageError('Artifact directory must be absolute')
            base = private_dir(base)
        else:
            base = Path(stack.enter_context(tempfile.TemporaryDirectory(prefix='sasid-image-')))
        key = hashlib.sha256(args.image.encode()).hexdigest()[:24]
        directory = private_dir(base / key)
        if args.transfer_only:
            manifest = transfer(directory, args.image, commit, args.host)
        else:
            manifest = build(args.source.resolve(), args.image, commit, directory, args)
            if not args.build_only:
                manifest = transfer(directory, args.image, commit, args.host)
        if source_identity(args.source, args.test_local_remotes) != commit:
            raise ImageError('Source changed during the image handoff')
        print(json.dumps(manifest))
    return 0


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except Deferred as error:
        print('mac-ci-image: ' + str(error), file=sys.stderr)
        raise SystemExit(75)
    except (ImageError, OSError, ValueError, KeyError, IndexError, TypeError, AttributeError, tarfile.TarError) as error:
        print('mac-ci-image: ' + (str(error) if isinstance(error, ImageError) else 'Image handoff failed closed'), file=sys.stderr)
        raise SystemExit(1)
