#!/usr/bin/env bash
# Deterministic API checks. Scraping and mobile/store releases are separate jobs.
set -euo pipefail
task_api="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$task_api"
node -e 'if(process.versions.node.split(".")[0]!=="22"){console.error("Arrahma API checks require Node22, matching Dockerfile.");process.exit(75)}'
# npm ci and npm test preserve the committed lockfile and every API contract test.
npm ci
npm test
for task_script in docker-entrypoint.sh scripts/ci-check.sh scripts/deploy-vps.sh scripts/rollback-vps.sh; do
  bash -n "$task_script"
done
git diff --check
