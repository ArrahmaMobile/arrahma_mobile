#!/usr/bin/env bash
#
# Emergency rollback: put the Arrahmah API back on its previously running image.
#
#   scripts/rollback-vps.sh              # back to ARRAHMAH_PREVIOUS_IMAGE
#   scripts/rollback-vps.sh <sha>        # back to a specific 12-char sha
#
# Fixing forward is still preferable — a rolled-back host and a green trunk
# disagree until someone reconciles them. Use this when production is down and
# forward is too slow.
#
# This touches no data. The only durable state is the scraped snapshot on the
# mounted volume, which every release reads as-is, so an image rollback is safe
# on its own; restoring a snapshot is a separate, destructive decision.

set -euo pipefail

task_host="${ARRAHMAH_DEPLOY_HOST:-deploy@152.53.192.214}"
task_domain="${ARRAHMAH_DOMAIN:-arrahmah.sasid.me}"
task_target="${1:-}"
task_tmp="$(mktemp -d "${TMPDIR:-/tmp}/arrahmah-rollback.XXXXXX")"
trap 'rm -rf "$task_tmp"' EXIT

fail() {
  echo "rollback: $*" >&2
  exit 1
}

command -v ssh  >/dev/null 2>&1 || fail "ssh is not on PATH"
command -v curl >/dev/null 2>&1 || fail "curl is not on PATH"
command -v node >/dev/null 2>&1 || fail "node is needed to read the health report"

if [ -n "$task_target" ] && ! printf '%s' "$task_target" | grep -Eq '^[0-9a-f]{7,40}$'; then
  fail "target must be a git sha (7-40 hex chars), got: ${task_target}"
fi

echo "rollback: target = ${task_target:-recorded previous image}"

ssh "$task_host" "bash -s -- '$task_target'" <<'REMOTE'
set -euo pipefail

task_target="${1:-}"
task_app="/opt/platform/apps/arrahmah"
task_container="arrahmah-arrahmah-1"
task_stamp="$(date -u +%Y%m%dT%H%M%SZ)"

fail() {
  echo "rollback(vps): $*" >&2
  exit 1
}

[ -f "$task_app/.env" ] || fail "missing $task_app/.env"
[ -f "$task_app/docker-compose.yml" ] || fail "missing $task_app/docker-compose.yml"
mkdir -p "$task_app/backups"

task_current="$(grep '^ARRAHMAH_IMAGE=' "$task_app/.env" | cut -d= -f2- || true)"

if [ -n "$task_target" ]; then
  task_image="arrahmah-api:${task_target}"
else
  task_image="$(grep '^ARRAHMAH_PREVIOUS_IMAGE=' "$task_app/.env" | cut -d= -f2- || true)"
  [ -n "$task_image" ] \
    || fail "no ARRAHMAH_PREVIOUS_IMAGE recorded — pass an explicit sha, e.g. rollback-vps.sh c21367efeac1"
fi

[ "$task_image" != "$task_current" ] \
  || fail "already running ${task_image}; nothing to roll back to"

docker image inspect "$task_image" >/dev/null 2>&1 \
  || fail "${task_image} is not on this host — list candidates with: docker images arrahmah-api"

echo "rollback(vps): ${task_current:-unknown} -> ${task_image}"

cp "$task_app/.env" "$task_app/backups/env.before-rollback-${task_stamp}"
chmod 600 "$task_app/backups/env.before-rollback-${task_stamp}"

set_env() {
  if grep -q "^$1=" "$task_app/.env"; then
    sed -i "s|^$1=.*|$1=$2|" "$task_app/.env"
  else
    printf '%s=%s\n' "$1" "$2" >> "$task_app/.env"
  fi
}

# The image we are leaving becomes the rollback target of the rollback, so a
# mistaken rollback is itself reversible.
if [ -n "$task_current" ]; then
  set_env ARRAHMAH_PREVIOUS_IMAGE "$task_current"
fi
set_env ARRAHMAH_IMAGE "$task_image"
set_env RELEASE_SHA "${task_image#arrahmah-api:}"
set_env RELEASE_AT "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cd "$task_app"

# --no-deps: this app only. The shared Caddy and platform network are not ours
# to recreate from here.
docker compose up -d --no-deps --force-recreate arrahmah || fail "compose up failed"

task_state=""
for _attempt in $(seq 1 90); do
  task_state="$(docker inspect \
    --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' \
    "$task_container" 2>/dev/null || true)"
  [ "$task_state" = "healthy" ] && break
  if [ "$task_state" = "unhealthy" ] || [ "$task_state" = "exited" ] || [ "$task_state" = "dead" ]; then
    docker compose logs --tail=150 arrahmah
    fail "container reported ${task_state} after rollback"
  fi
  sleep 2
done

[ "$task_state" = "healthy" ] \
  || { docker compose logs --tail=150 arrahmah; fail "container did not become healthy within 180s (last state: ${task_state:-unknown})"; }

docker compose ps
echo "rollback(vps): ${task_image} is live"
REMOTE

echo "rollback: asserting the public https://${task_domain}/_health report"
task_body="$task_tmp/health.json"
curl --fail --silent --show-error \
  --retry 10 --retry-delay 3 --retry-connrefused \
  --max-time 20 \
  --output "$task_body" \
  "https://${task_domain}/_health" \
  || fail "public health endpoint did not answer 2xx at https://${task_domain}/_health"

ARRAHMAH_HEALTH_JSON="$(cat "$task_body")" node -e '
const body = JSON.parse(process.env.ARRAHMAH_HEALTH_JSON);
const healthy = ["operational", "degraded", "maintenance"];
const components = Array.isArray(body.components) ? body.components : [];

for (const component of components) {
  console.log(`  ${String(component.status).padEnd(12)} ${component.required ? "required" : "optional"}  ${component.name}`);
}
console.log(`  aggregate: ${body.status} — ${body.summary}`);
console.log(`  commit: ${body.application && body.application.commit ? body.application.commit : "not reported"}`);

const broken = components.filter((c) => c.required && c.status === "outage");
if (broken.length > 0) {
  console.error(`FAIL: required components down: ${broken.map((c) => c.name).join(", ")}`);
  process.exit(1);
}
if (!healthy.includes(body.status)) {
  console.error(`FAIL: aggregate status is ${body.status}`);
  process.exit(1);
}
' || fail "the public readiness report is not acceptable after rollback"

echo
echo "rollback: complete and verified at https://${task_domain}"
echo "rollback: fix forward on master — a rolled-back host and a green trunk disagree until you do."
