# Progress log (append-only)

## 2026-09-30
- Project created: Hugo site skeleton (layouts, style, about/disclosure pages), topic queue seeded with 30 topics (state/queue.json).
- scripts/generate_article.sh written: picks next undone topic, generates via LLM backend (claude-cli default, LLM_BACKEND=ollama supported), writes content/posts/<slug>.md, marks done. Failure-safe: backend errors are NOT marked done.
- scripts/build.sh written: generate + hugo --minify.
- Backend status: claude CLI → 401 OAuth revoked; ollama → system service crash-looping (models dir /media/ta/Games/jasmin/.ollama unreachable — Games disk not mounted; NOT caused by this project; ad-hoc `ollama serve` was started and killed again to restore service attempts); gemini CLI → waiting for authentication.
- Smoke proof: hugo build OK (public/ with sitemap.xml, robots.txt, posts); served public/ over localhost:8791, posts and home return 200 with correct title.
- First two articles written by the parent agent directly (backends down): best-ai-writing-tools.md, otter-ai-review.md. Marked done in queue. 28 topics remain.

## Blocked on (human)
1. LLM backend for automated generation: EITHER re-auth claude CLI (`claude login`) OR mount the Games disk so ollama service can start. See notes/backend.md.
2. Domain purchase (€10) — then update baseURL in hugo.toml.
3. Deployment repo (git init + push) — needs user approval per repo rules.
4. Affiliate program signups (checklist in notes/affiliate-programs.md) — needs live site first, so do after deploy.

## 2026-09-30 (update 2)
- LLM backend switched to local GX10 (user choice): vLLM OpenAI-API at http://10.10.10.40:8888/v1, model glm-5.3-flash-nvfp4. Env: GX10_BASE_URL, GX10_MODEL, GX10_TIMEOUT.
- Key fix: must send reasoning_effort:"low" or the model emits content:null (reasoning eats the budget) — same trap documented in mcp-gx10/README.
- First agent-generated article via GX10: best-ai-transcription-tools.md (9.9 KB); generation 2m17s.
- Fixed queue-restoration bug (earlier map/select dropped 28 topics — restored).
- generate_article.sh now strips the duplicate H1 from generated bodies.
- Verified: hugo build 15 pages, public/ served OK; empty leftover artifact from an interrupted run removed; queue intact (27 remaining).

## 2026-09-30 (update 3)
- BUG (user-reported): all links broken at github.io URL. Cause: baseURL pointed at soundfrequency.online with no DNS. My earlier verification checked only homepage 200 — insufficient. Fixed via relativeURLs + relative home link; user lesson persisted in notes/lessons-mine.md.
- Redeployed, verified ALL 7 URLs externally: all 200, links relative on subpages too.
- Still NOT done: DNS records in Squarespace (human), affiliate signups (human), daily cron (not yet approved).

## 2026-09-30 (update 4)
- Renamed project+repo to toolstack (user low-exposure preference); verified new URL 200, old 404, cron path updated.
- User checked empty bullets — treated as report to verify (HTML scan shows none; awaiting page pointer).
- Daily plan agreed: user does DNS → affiliate signups → Search Console; agent does CTA layout upgrade + link insertion.
## 2026-09-30 (afternoon): Domain cutover completed
- Bought toolstack.page (user, Squarespace). CNAME file + hugo.toml baseURL updated; brand "Tool Stack Reviews"; queue restored to general niche order (60 topics, no prio).
- GitHub Pages: custom domain set via API, TLS cert approved (toolstack.page + www, expires 2026-12-29), HTTPS enforced, HTTP→HTTPS 301 verified.
- Verified live: https://toolstack.page/ 200, /terms/ 200, /disclosure/ 200, /sitemap.xml 200.
- Content now 5 articles (best-ai-podcast-tools generated mid-day via daily.sh, run 36723741842 success). Article 6 (jasper-review) scheduled cron 06:00.
- New pages: terms.md (ToS). Logo static/logo.png published.
- LinkedIn company page created by user: https://www.linkedin.com/company/toolstack-reviews/
- PartnerStack profile/applications: user completing (affiliate+publisher, Germany, EU audience).
- Pending: Impressum needs user data (registered name/address/email/tax-ID). Affiliate links = placeholders until program approvals.
