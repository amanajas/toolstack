#!/usr/bin/env bash
# build.sh — full loop: generate one new article, then build the Hugo site.
# Reads:      state/queue.json, content/posts/
# Writes:     content/posts/<slug>.md, public/
# Idempotent: re-running when backlog is empty just rebuilds.
set -euo pipefail
cd "$(dirname "$0")/.."

bash scripts/generate_article.sh
hugo --minify
echo "Site built → $(pwd)/public"
