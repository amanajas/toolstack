#!/usr/bin/env bash
# generate_article.sh — write the next undone article from state/queue.json.
# Reads:      state/queue.json, notes/niche.md
# Writes:     content/posts/<slug>.md, updates state/queue.json ("done": true)
# Idempotent: skips topics already marked done. Re-running never duplicates.
set -euo pipefail
cd "$(dirname "$0")/.."

SLUG=$(jq -r '[.[] | select(.done == false)][0].slug // empty' state/queue.json)
if [ -z "$SLUG" ]; then echo "Backlog empty — all topics done."; exit 0; fi

TOPIC=$(jq -r --arg s "$SLUG" '.[] | select(.slug == $s)' state/queue.json)
TITLE=$(jq -r '.title' <<<"$TOPIC")
KEYWORD=$(jq -r '.keyword' <<<"$TOPIC")
TYPE=$(jq -r '.type' <<<"$TOPIC")
OUT="content/posts/$SLUG.md"

if [ -f "$OUT" ]; then
  echo "$OUT already exists; marking done and exiting." >&2
  jq --arg s "$SLUG" 'map(if .slug == $s then .done = true else . end)' state/queue.json > state/queue.tmp && mv state/queue.tmp state/queue.json
  exit 0
fi

GEN_OK=0
BASE_URL="${GX10_BASE_URL:-http://10.10.10.40:8888/v1}"
MODEL="${GX10_MODEL:-glm-5.3-flash-nvfp4}"
RELATED=""
if SLUGS=$(jq -r '[.[]|select(.done==true)][0:10][]|" - \(.["title"]) → link path: /posts/\(.["slug"])/ (\(."keyword"))"' state/queue.json 2>/dev/null) && [ -n "$SLUGS" ]; then
  RELATED="Already published on this site (link naturally to 1-3 of these where relevant, using Hugo relref shortcodes, e.g. [Otter.ai review]({{< relref \"/posts/otter-ai-review\" >}})):
$SLUGS
"
fi
PROMPT="You are a senior affiliate-content writer. Write a complete, honest, well-structured blog post in Markdown for a static site about AI and productivity software.

Topic type: $TYPE
Title: $TITLE
Primary keyword: $KEYWORD
$RELATED
Requirements:
- 900-1400 words, H2/H3 structure, comparison table where useful
- factual, current to your knowledge; avoid invented exact prices (write 'see current pricing')
- include a short 'Who this is for' and 'Alternatives' section
- no affiliate links (placeholder [#AFF-LINK-<product>] wherever a link belongs)
- output ONLY the markdown body, no H1 title line, no preamble"

case "${LLM_BACKEND:-gx10}" in
  gx10)
    curl -s -m "${GX10_TIMEOUT:-600}" "$BASE_URL/chat/completions" -H 'Content-Type: application/json' -d "$(jq -n \
      --arg m "$MODEL" --arg p "$PROMPT" \
      '{model:$m, messages:[{role:"user",content:$p}], temperature:0.7, max_tokens:4000, reasoning_effort:"low"}')" \
      | jq -r '.choices[0].message.content // empty' > "$OUT"
    [ "$(wc -c < "$OUT")" -gt 3000 ] && GEN_OK=1
    ;;
  claude-cli)
    claude -p --output-format text "$PROMPT" > "$OUT"
    if ! grep -q "API Error" "$OUT" && [ "$(wc -c < "$OUT")" -gt 3000 ]; then GEN_OK=1; fi
    ;;
  ollama)
    curl -s localhost:11434/api/generate -d "$(jq -n --arg k "$KEYWORD" --arg t "$TITLE" \
      '{model:"qwen3:14b", stream:false, prompt:("Write a 900-1400 word honest Markdown blog post about: "+$t+" (keyword: "+$k+"). H2/H3 structure, comparison table, no invented exact prices, output only markdown body.")}')" \
      | jq -r '.response' > "$OUT"
    [ "$(wc -c < "$OUT")" -gt 3000 ] && GEN_OK=1
    ;;
  *) echo "Unknown LLM_BACKEND=$LLM_BACKEND" >&2; exit 1;;
esac

if [ "$GEN_OK" -ne 1 ]; then
  echo "Generation FAILED for $SLUG; not marked done. Backend: ${LLM_BACKEND:-claude-cli}. Output kept at $OUT for inspection." >&2
  exit 1
fi

# Strip leading H1 (duplicates frontmatter title)
awk 'NR==1 && /^# /{next} {print}' "$OUT" > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"

# Prepend frontmatter
TMP=$(mktemp)
{ printf -- '---\ntitle: "%s"\ndate: %s\ndraft: false\ndescription: "%s reviewed by the ToolStack team. Honest pros, cons, and alternatives."\n---\n\n' \
    "$TITLE" "$(date -I)" "$KEYWORD"; cat "$OUT"; } > "$TMP"
mv "$TMP" "$OUT"

jq --arg s "$SLUG" --arg f "$OUT" 'map(if .slug == $s then .done = true | .file = $f else . end)' \
  state/queue.json > state/queue.tmp && mv state/queue.tmp state/queue.json
echo "Generated $OUT"
