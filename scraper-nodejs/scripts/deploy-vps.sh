#!/usr/bin/env bash
# Local AMD64 image build and verified SSH load. App data and rollback stay intact.
# shellcheck disable=SC2029
set -euo pipefail
umask 077
task_api="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
task_root="$(git -C "$task_api" rev-parse --show-toplevel)"
task_sha="$(git -C "$task_root" rev-parse HEAD)"
task_host="${ARRAHMAH_DEPLOY_HOST:-deploy@152.53.192.214}"
task_image="arrahmah-api:$task_sha"
task_released_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
task_phase=()
for task_arg in "$@"; do
  case "$task_arg" in
    --build-only|--transfer-only)
      [ "${#task_phase[@]}" -eq 0 ] || { echo 'Choose one image phase.' >&2; exit 1; }
      task_phase=("$task_arg") ;;
    "$task_sha"|"${task_sha:0:12}") ;;
    *) echo 'Use deploy-vps.sh [--build-only|--transfer-only] [current-sha].' >&2; exit 1 ;;
  esac
done
[ -z "$(git -C "$task_root" status --porcelain)" ] || { echo 'Release requires clean committed source.' >&2; exit 1; }
[ "$(git -C "$task_root" branch --show-current)" = master ] || { echo 'Arrahma releases require master.' >&2; exit 1; }
"$task_api/scripts/ci-check.sh"
task_tmp="$(mktemp -d "${TMPDIR:-/tmp}/arrahmah-deploy.XXXXXXXX")"
task_stage=''
cleanup() {
  rm -rf -- "$task_tmp"
  if [ -n "$task_stage" ]; then ssh -o BatchMode=yes "$task_host" "rm -rf -- '$task_stage'" >/dev/null 2>&1 || true; fi
}
trap cleanup EXIT
python3 "$task_api/scripts/mac-ci-image.py" --source "$task_root" --context scraper-nodejs \
  --image "$task_image" --host "$task_host" --pull ${task_phase[@]+"${task_phase[@]}"} > "$task_tmp/image.json"
task_image_id="$(python3 - "$task_tmp/image.json" "$task_sha" "$task_image" "${task_phase[0]:-}" <<'IDENTITY'
import json,re,sys
receipt=json.load(open(sys.argv[1]))
if (receipt.get('commit')!=sys.argv[2] or receipt.get('imageTag')!=sys.argv[3] or
    not re.fullmatch(r'sha256:[a-f0-9]{64}',receipt.get('imageId','')) or
    receipt.get('loaded')!=(sys.argv[4]!='--build-only')):raise SystemExit('Invalid image handoff receipt')
print(receipt['imageId'])
IDENTITY
)"
if [ "${task_phase[0]:-}" = --build-only ]; then
  echo "Arrahma image built for $task_sha; production was not changed."
  exit 0
fi
task_stage="$(ssh -o BatchMode=yes "$task_host" "umask 077; mktemp -d /tmp/arrahmah-release-${task_sha:0:12}.XXXXXXXX")"
[[ "$task_stage" =~ ^/tmp/arrahmah-release-[a-f0-9]{12}\.[a-zA-Z0-9]{8}$ ]] || { task_stage=''; exit 1; }
scp "$task_api/deploy/docker-compose.vps.yml" "$task_host:$task_stage/compose.yml"
ssh "$task_host" "bash -s -- '$task_sha' '$task_released_at' '$task_stage' '$task_image_id'" <<'REMOTE'
set -euo pipefail
umask 077
exec 8>/opt/platform/.hackathon-rollout.lock
flock -n -E 75 8 || exit 75
python3 - <<'SASID_ADMISSION'
import subprocess,sys
try:
 available=next(int(line.split()[1]) for line in open('/proc/meminfo') if line.startswith('MemAvailable:'))
 result=subprocess.run(['docker','exec','platform-postgres-1','psql','-U','postgres','-d','postgres','-Atqc','select count(*) from pg_stat_activity;'],capture_output=True,text=True,check=True,timeout=15)
 connections=int(result.stdout.strip())
 if connections<0 or connections>=80 or available<1572864:raise ValueError()
except Exception:
 print('VPS release deferred: freshPG<80 and MemAvailable>=1.5GiB required',file=sys.stderr);sys.exit(75)
SASID_ADMISSION
task_sha="$1"
task_released_at="$2"
task_stage="$3"
task_image_id="$4"
task_app="/opt/platform/apps/arrahmah"
task_stamp="$(date -u +%Y%m%dT%H%M%SZ)"

test -s "$task_app/data/scraped_data.json"
[ "$(docker image inspect "arrahmah-api:$task_sha" --format '{{.Id}}')" = "$task_image_id" ]
[ "$(docker image inspect "arrahmah-api:$task_sha" --format '{{index .Config.Labels "org.opencontainers.image.revision"}}')" = "$task_sha" ]
mkdir -p "$task_app/backups" "$task_app/data"

# Back up the live contract and secrets before touching either.
if [ -f "$task_app/docker-compose.yml" ]; then
  cp "$task_app/docker-compose.yml" \
    "$task_app/backups/docker-compose.before-${task_sha}-${task_stamp}.yml"
fi
if [ -f "$task_app/.env" ]; then
  cp "$task_app/.env" "$task_app/backups/env.before-${task_sha}-${task_stamp}"
  chmod 600 "$task_app/backups/env.before-${task_sha}-${task_stamp}"
else
  echo "Missing $task_app/.env; provision PRODUCT_STATS_TOKEN first." >&2
  exit 1
fi

# This app stores its durable state in JSON, not in the shared PostgreSQL.
# Preserve and verify snapshot/journal/broadcast metadata before any replacement.
task_data_backup="$task_app/backups/data.before-${task_sha}-${task_stamp}.tar.gz"
tar -czf "$task_data_backup.partial" -C "$task_app/data" .
gzip -t "$task_data_backup.partial"
tar -tzf "$task_data_backup.partial" >/dev/null
mv "$task_data_backup.partial" "$task_data_backup"
(cd "$task_app/backups" && sha256sum "$(basename "$task_data_backup")" > "$(basename "$task_data_backup").sha256" && sha256sum -c "$(basename "$task_data_backup").sha256")
install -m 0644 "$task_stage/compose.yml" "$task_app/docker-compose.yml"

set_env() {
  if grep -q "^$1=" "$task_app/.env"; then
    sed -i "s|^$1=.*|$1=$2|" "$task_app/.env"
  else
    printf '%s=%s\n' "$1" "$2" >> "$task_app/.env"
  fi
}

# Record what we are replacing, so scripts/rollback-vps.sh has a target that
# does not depend on anyone remembering the previous sha at 3am.
task_container="$(docker compose --project-directory "$task_app" -f "$task_app/docker-compose.yml" --env-file "$task_app/.env" ps -q arrahmah)"
task_outgoing=''
if [ -n "$task_container" ]; then task_outgoing="$(docker inspect --format '{{.Config.Image}}' "$task_container")"; fi
if [ -z "$task_outgoing" ]; then task_outgoing="$(grep '^ARRAHMAH_IMAGE=' "$task_app/.env" | cut -d= -f2- || true)"; fi
if [ -n "$task_outgoing" ] && [ "$task_outgoing" != "arrahmah-api:${task_sha}" ]; then
  set_env ARRAHMAH_PREVIOUS_IMAGE "$task_outgoing"
fi

set_env ARRAHMAH_IMAGE "arrahmah-api:${task_sha}"
set_env RELEASE_SHA "${task_sha}"
set_env RELEASE_AT "${task_released_at}"
chmod 600 "$task_app/.env"

cd "$task_app"

# There is no schema migration in this application: the only durable state is
# the scraped snapshot on the mounted volume, which every release reads as-is.
# The equivalent pre-flight is proving the new image can start and assemble its
# own health report before the serving container is replaced.
mkdir "$task_stage/candidate-data"
tar -xzf "$task_data_backup" -C "$task_stage/candidate-data"
docker compose run --rm --no-deps -T \
  -v "$task_stage/candidate-data:/app/data" -e PORT=8899 \
  arrahmah node -e '
    const { ArrahmahAPIServer } = require("/app/dist/api/server.js");
    const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
    (async () => {
      await new ArrahmahAPIServer(8899).start();
      for (let attempt = 1; attempt <= 30; attempt += 1) {
        try {
          const response = await fetch("http://localhost:8899/_health", { signal: AbortSignal.timeout(5000) });
          const body = await response.json();
          if (!response.ok || body.schemaVersion !== "1.0" || body.application.id !== "arrahmah" || body.application.commit !== process.argv[1] || !["operational", "degraded", "maintenance"].includes(body.status)) {
            throw new Error("health report is not a v1 arrahmah report");
          }
          console.log("preflight " + response.status + " " + body.status);
          process.exit(0);
        } catch (error) {
          if (attempt === 30) throw error;
          await sleep(1000);
        }
      }
    })().catch((error) => { console.error(error); process.exit(1); });
  ' "$task_sha" </dev/null

docker compose config --quiet
docker compose up -d --no-deps --no-build --pull never arrahmah

task_ready=0
for task_attempt in $(seq 1 90); do
  if docker compose exec -T arrahmah node -e '
const expected=process.argv[1];fetch("http://127.0.0.1:8888/_health",{signal:AbortSignal.timeout(5000)}).then(async response=>{const body=await response.json();if(!response.ok||body.schemaVersion!=="1.0"||body.application?.id!=="arrahmah"||body.application?.commit!==expected||!["operational","degraded","maintenance"].includes(body.status))process.exit(1);console.log("Arrahma internal readiness: "+body.status+" "+expected)}).catch(()=>process.exit(1))
  ' "$task_sha"; then task_ready=1; break; fi
  echo "Arrahma readiness attempt $task_attempt/90 failed" >&2
  sleep 2
done
if [ "$task_ready" -ne 1 ]; then
  echo 'Arrahma readiness failed. Backups are retained. Use scripts/rollback-vps.sh; data restore is separate.' >&2
  exit 1
fi
# Bound only this script's checksum-verified JSON recovery archives. Preserve
# other backups, symlinks, corrupt receipts and every source data file.
python3 - "$task_app/backups" <<'ARRAHMAH_RETENTION'
import hashlib,pathlib,re,stat,sys
base=pathlib.Path(sys.argv[1]);archives=[]
pattern=re.compile(r'data\.before-[a-f0-9]{40}-(\d{8}T\d{6}Z)\.tar\.gz')
for path in base.iterdir():
 match=pattern.fullmatch(path.name)
 if match and stat.S_ISREG(path.lstat().st_mode) and path.lstat().st_nlink==1:archives.append((match[1],path))
for _,path in sorted(archives,reverse=True)[3:]:
 receipt=pathlib.Path(str(path)+'.sha256')
 if not receipt.exists() or not stat.S_ISREG(receipt.lstat().st_mode) or receipt.lstat().st_nlink!=1:continue
 expected=receipt.read_text().strip().split()
 if len(expected)!=2 or expected[1]!=path.name or not re.fullmatch('[a-f0-9]{64}',expected[0]):continue
 before=path.lstat();digest=hashlib.sha256()
 with path.open('rb') as stream:
  for chunk in iter(lambda:stream.read(1048576),b''):digest.update(chunk)
 after=path.lstat()
 identity=lambda entry:(entry.st_dev,entry.st_ino,entry.st_mode,entry.st_size,entry.st_mtime_ns,entry.st_ctime_ns,entry.st_nlink)
 if identity(before)!=identity(after) or digest.hexdigest()!=expected[0]:continue
 path.unlink();receipt.unlink()
ARRAHMAH_RETENTION
exit 0
REMOTE

# The exact public revision proves the new container is routed through Caddy.
curl --fail --silent --show-error --max-time 20 --retry 10 --retry-delay 3 \
  -A sasid-internal-release/1.0 -H 'X-Sasid-Internal: 1' https://arrahmah.sasid.me/_health | node -e '
let text="";process.stdin.on("data",chunk=>text+=chunk).on("end",()=>{const body=JSON.parse(text);if(body.schemaVersion!=="1.0"||body.application?.id!=="arrahmah"||body.application?.commit!==process.argv[1]||!["operational","degraded","maintenance"].includes(body.status))process.exit(1);console.log("Public Arrahma release verified: "+process.argv[1])})
' "$task_sha"
