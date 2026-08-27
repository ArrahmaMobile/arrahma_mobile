#!/usr/bin/env bash
#
# Deploy the Arrahmah API to the shared SASID VPS without GitHub Actions.
#
# The Actions budget on this account runs out, and when it does every workflow
# fails before it starts. A release path that stops working when a billing
# meter trips is not a release path, so this script owes nothing to CI, to a
# registry, or to the remote being reachable: it builds locally for
# linux/amd64, ships the image over SSH, and pins the live compose file to an
# immutable `arrahmah-api:<sha>` tag so a rollback names the code it ran.
#
# Usage: scripts/deploy-vps.sh [sha]

set -euo pipefail

task_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
task_host="${ARRAHMAH_DEPLOY_HOST:-deploy@152.53.192.214}"
task_sha="${1:-$(git -C "$task_root" rev-parse --short=12 HEAD)}"
task_image="arrahmah-api:${task_sha}"
task_released_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
task_tmp="$(mktemp -d "${TMPDIR:-/tmp}/arrahmah-deploy.XXXXXX")"
trap 'rm -rf "$task_tmp"' EXIT

# The tag has to describe the image contents, or a rollback lies about what it
# is rolling back to.
if ! git -C "$task_root" diff --quiet -- "$task_root" ||
   ! git -C "$task_root" diff --cached --quiet -- "$task_root"; then
  echo "Refusing to deploy an uncommitted source tree." >&2
  exit 1
fi

echo "Building immutable ${task_image} for linux/amd64"
docker buildx build \
  --platform linux/amd64 \
  --pull \
  --load \
  --tag "$task_image" \
  "$task_root"

docker save "$task_image" | gzip -1 > "$task_tmp/image.tar.gz"
cp "$task_root/deploy/docker-compose.vps.yml" "$task_tmp/docker-compose.yml"

scp "$task_tmp/image.tar.gz" "$task_tmp/docker-compose.yml" "${task_host}:/tmp/"

ssh "$task_host" "bash -s -- '$task_sha' '$task_released_at'" <<'REMOTE'
set -euo pipefail
task_sha="$1"
task_released_at="$2"
task_app="/opt/platform/apps/arrahmah"
task_stamp="$(date -u +%Y%m%dT%H%M%SZ)"

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

gzip -dc /tmp/image.tar.gz | docker load
install -m 0644 /tmp/docker-compose.yml "$task_app/docker-compose.yml"
rm -f /tmp/image.tar.gz /tmp/docker-compose.yml

set_env() {
  if grep -q "^$1=" "$task_app/.env"; then
    sed -i "s|^$1=.*|$1=$2|" "$task_app/.env"
  else
    printf '%s=%s\n' "$1" "$2" >> "$task_app/.env"
  fi
}
set_env ARRAHMAH_IMAGE "arrahmah-api:${task_sha}"
set_env RELEASE_SHA "${task_sha}"
set_env RELEASE_AT "${task_released_at}"
chmod 600 "$task_app/.env"

cd "$task_app"

# There is no schema migration in this application: the only durable state is
# the scraped snapshot on the mounted volume, which every release reads as-is.
# The equivalent pre-flight is proving the new image can start and assemble its
# own health report before the serving container is replaced.
docker compose run --rm --no-deps -T \
  -e PORT=8899 \
  arrahmah node -e '
    const { ArrahmahAPIServer } = require("/app/dist/api/server.js");
    const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
    (async () => {
      await new ArrahmahAPIServer(8899).start();
      for (let attempt = 1; attempt <= 30; attempt += 1) {
        try {
          const response = await fetch("http://localhost:8899/_health");
          const body = await response.json();
          if (body.schemaVersion !== "1.0" || body.application.id !== "arrahmah") {
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
  ' </dev/null

docker compose up -d --no-deps arrahmah

for task_attempt in $(seq 1 90); do
  task_health="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' arrahmah-arrahmah-1 2>/dev/null || true)"
  if [ "$task_health" = "healthy" ]; then
    docker compose ps
    exit 0
  fi
  if [ "$task_health" = "unhealthy" ] || [ "$task_health" = "exited" ]; then
    docker compose logs --tail=120 arrahmah
    exit 1
  fi
  sleep 2
done

docker compose logs --tail=120 arrahmah
echo "Arrahmah did not become healthy in time." >&2
exit 1
REMOTE

# Container health only proves the process started. The public URL proves Caddy
# routes to it and the certificate is valid.
curl --fail --silent --show-error \
  --retry 10 \
  --retry-delay 3 \
  "https://arrahmah.sasid.me/_health" > /dev/null
echo "Deployed ${task_image}"
