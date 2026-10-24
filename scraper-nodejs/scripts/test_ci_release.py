#!/usr/bin/env python3
"""Execute the release shell with owned command fixtures. No Docker or SSH access."""
import json
import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

SCRIPTS = Path(__file__).resolve().parent
SHA = 'a' * 40


class ReleaseTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix='arrahma-release-fixture-')
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.source = self.root / 'source'
        self.scripts = self.source / 'scraper-nodejs/scripts'
        self.scripts.mkdir(parents=True)
        for name in ('ci-check.sh', 'deploy-vps.sh', 'rollback-vps.sh', 'mac-ci-image.py'):
            shutil.copy2(SCRIPTS / name, self.scripts / name)
        api = self.scripts.parent
        (api / 'docker-entrypoint.sh').write_text('#!/bin/sh\nexit 0\n')
        (api / 'deploy').mkdir()
        (api / 'deploy/docker-compose.vps.yml').write_text('services: {}\n')
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.log = self.root / 'commands.ndjson'
        self.remote = self.root / 'remote.sh'
        tool = self.bin / 'tool.py'
        tool.write_text('''#!''' + sys.executable + '''
import json,os,pathlib,sys
name=pathlib.Path(sys.argv[0]).name;args=sys.argv[1:]
with open(os.environ['FIXTURE_LOG'],'a') as stream:stream.write(json.dumps([name,args])+'\\n')
sha='a'*40
if name=='git':
 if '--show-toplevel' in args:print(os.environ['FIXTURE_SOURCE'])
 elif 'rev-parse' in args:print(sha)
 elif 'status' in args:print(' M file' if os.environ.get('FIXTURE_DIRTY') else '')
 elif 'branch' in args:print('master')
 elif 'diff' in args:pass
 else:sys.exit(99)
elif name=='node':
 if not ('process.versions' in args[1] if len(args)>1 else False):sys.stdin.read()
 sys.exit(int(os.environ.get('FIXTURE_NODE_EXIT','0')))
elif name=='npm':
 if args==['test']:sys.exit(int(os.environ.get('FIXTURE_TEST_EXIT','0')))
elif name=='python3':
 if args and args[0].endswith('/mac-ci-image.py'):
  if os.environ.get('FIXTURE_HELPER_EXIT'):sys.exit(int(os.environ['FIXTURE_HELPER_EXIT']))
  image=args[args.index('--image')+1]
  print(json.dumps({'commit':sha,'imageTag':image,'imageId':'sha256:'+'b'*64,'loaded':'--build-only' not in args and not os.environ.get('FIXTURE_BAD_RECEIPT')}))
 else:os.execv(os.environ['FIXTURE_PYTHON'],[os.environ['FIXTURE_PYTHON'],*args])
elif name=='ssh':
 command=args[-1]
 if 'mktemp' in command:print('/tmp/arrahmah-release-'+sha[:12]+'.ABCDEFGH')
 elif 'bash -s' in command:
  pathlib.Path(os.environ['FIXTURE_REMOTE']).write_text(sys.stdin.read());sys.exit(int(os.environ.get('FIXTURE_REMOTE_EXIT','0')))
elif name=='curl':
 print(json.dumps({'schemaVersion':'1.0','application':{'id':'arrahmah','commit':sha},'status':'operational'}))
elif name!='scp':sys.exit(99)
''')
        tool.chmod(0o755)
        for name in ('git', 'npm', 'node', 'python3', 'ssh', 'scp', 'curl'):
            (self.bin / name).symlink_to(tool.name)
        self.env = dict(os.environ, PATH=str(self.bin) + ':/usr/bin:/bin',
                        FIXTURE_LOG=str(self.log), FIXTURE_SOURCE=str(self.source),
                        FIXTURE_REMOTE=str(self.remote), FIXTURE_PYTHON=sys.executable,
                        ARRAHMAH_DEPLOY_HOST='deploy@fixture.invalid')

    def invoke(self, *args, **env):
        return subprocess.run(['/bin/bash', str(self.scripts / 'deploy-vps.sh'), *args],
                              env=dict(self.env, **env), capture_output=True, text=True, timeout=20)

    def commands(self):
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def test_full_release_checks_exact_source_context_then_transfers_before_mutation(self):
        result = self.invoke()
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = self.commands()
        self.assertEqual([args for name, args in calls if name == 'npm'], [['ci'], ['test']])
        helper = next(args for name, args in calls if name == 'python3' and args[0].endswith('mac-ci-image.py'))
        self.assertEqual(helper[helper.index('--context') + 1], 'scraper-nodejs')
        self.assertEqual(helper[helper.index('--source') + 1], str(self.source))
        self.assertEqual(helper[helper.index('--image') + 1], 'arrahmah-api:' + SHA)
        remote = self.remote.read_text()
        self.assertLess(remote.index('SASID_ADMISSION'), remote.index('install -m'))
        self.assertIn('/opt/platform/.hackathon-rollout.lock', remote)
        self.assertIn('connections>=80', remote)
        self.assertIn('available<1572864', remote)
        self.assertIn('sha256sum -c', remote)
        self.assertIn('candidate-data:/app/data', remote)
        self.assertIn('body.application.commit !== process.argv[1]', remote)
        self.assertIn('--no-build --pull never', remote)
        self.assertNotIn('docker build', remote)
        self.assertNotIn('docker load', remote)
        self.assertTrue(any(name == 'curl' and 'X-Sasid-Internal: 1' in args for name, args in calls))

    def test_build_only_performs_no_ssh_or_release(self):
        result = self.invoke('--build-only')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(any(name in ('ssh', 'scp', 'curl') for name, _ in self.commands()))
        self.assertFalse(self.remote.exists())

    def test_transfer_only_requires_honest_loaded_receipt(self):
        result = self.invoke('--transfer-only', FIXTURE_BAD_RECEIPT='1')
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(any(name in ('ssh', 'scp', 'curl') for name, _ in self.commands()))

    def test_failed_checks_and_dirty_source_never_reach_image_helper(self):
        for env in ({'FIXTURE_TEST_EXIT': '9'}, {'FIXTURE_DIRTY': '1'}, {'FIXTURE_NODE_EXIT': '75'}):
            self.log.unlink(missing_ok=True)
            with self.subTest(env=env):
                result = self.invoke(**env)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(any(name in ('python3', 'ssh', 'scp', 'curl') for name, _ in self.commands()))

    def test_helper_and_remote_deferral_propagate_without_false_public_success(self):
        for env in ({'FIXTURE_HELPER_EXIT': '75'}, {'FIXTURE_REMOTE_EXIT': '75'}):
            self.log.unlink(missing_ok=True)
            with self.subTest(env=env):
                result = self.invoke(**env)
                self.assertEqual(result.returncode, 75, result.stderr)
                self.assertFalse(any(name == 'curl' for name, _ in self.commands()))

    def test_wrong_revision_and_conflicting_phases_fail_before_checks(self):
        for args in (['c' * 40], ['--build-only', '--transfer-only']):
            self.log.unlink(missing_ok=True)
            with self.subTest(args=args):
                result = self.invoke(*args)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(any(name in ('npm', 'python3', 'ssh') for name, _ in self.commands()))

    def test_data_recovery_retention_is_bounded_and_preserves_unverified_files(self):
        backups = self.root / 'backups'
        backups.mkdir()
        archives = []
        for day in range(1, 5):
            path = backups / ('data.before-' + SHA + f'-2026100{day}T120000Z.tar.gz')
            path.write_bytes(b'owned recovery archive ' + bytes([day]))
            Path(str(path) + '.sha256').write_text(hashlib.sha256(path.read_bytes()).hexdigest() + '  ' + path.name + '\n')
            archives.append(path)
        corrupt = backups / ('data.before-' + SHA + '-20260930T120000Z.tar.gz')
        corrupt.write_bytes(b'preserve damaged archive')
        Path(str(corrupt) + '.sha256').write_text('0' * 64 + '  ' + corrupt.name + '\n')
        unrelated = backups / 'prior-recovery.tar.gz'
        unrelated.write_bytes(b'not owned by this release script')
        link = backups / ('data.before-' + 'c' * 40 + '-20260929T120000Z.tar.gz')
        link.symlink_to(unrelated.name)
        script = (self.scripts / 'deploy-vps.sh').read_text().split("<<'ARRAHMAH_RETENTION'\n", 1)[1].split('\nARRAHMAH_RETENTION', 1)[0]
        result = subprocess.run([sys.executable, '-c', script, str(backups)], capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(archives[0].exists())
        self.assertTrue(all(path.exists() for path in archives[1:]))
        self.assertEqual(corrupt.read_bytes(), b'preserve damaged archive')
        self.assertEqual(unrelated.read_bytes(), b'not owned by this release script')
        self.assertTrue(link.is_symlink())


if __name__ == '__main__':
    unittest.main()
