#!/usr/bin/env bash
# daily.sh — cron entrypoint: generate one article, build, commit, push.
# Reads:      state/queue.json
# Writes:     content/posts/<slug>.md, state/cron.log, git history
# Idempotent: failed generation never commits; re-runs skip when backlog is empty.
set -uo pipefail
cd "$(dirname "$0")/.."
echo "[$(date -Is)] run start" >> state/cron.log

if ! bash scripts/build.sh >> state/cron.log 2>&1; then
  echo "[$(date -Is)] generation/build FAILED" >> state/cron.log
  exit 1
fi

if git status --porcelain | grep -q 'content/'; then
  git add -A
  git -c user.name=amanajas -c user.email=amanajas@users.noreply.github.com \
    commit -m "Daily: article + rebuild $(date -I)" >/dev/null
  git push >> state/cron.log 2>&1 || {
    echo "[$(date -Is)] PUSH FAILED" >> state/cron.log; exit 1; }
  echo "[$(date -Is)] committed+pushed" >> state/cron.log
else
  echo "[$(date -Is)] nothing new to publish" >> state/cron.log
fi
