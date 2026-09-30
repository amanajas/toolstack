# toolstack — automated affiliate content site

## Goal
Build a programmatic-SEO content site in the **"AI tools & productivity software"** niche that earns **≥ €200/month** through recurring SaaS affiliate commissions, with the agent doing 90% of the work.

## Architecture
- `content/` — Hugo articles, one per keyword from `state/queue.json`
- `scripts/pick_topic.py` — pulls next topic from queue (skips done, idempotent)
- `scripts/generate_article.py` — writes the article markdown via configured LLM backend
- `scripts/build.sh` — runs full loop: pick → generate → build
- `state/queue.json` — topic backlog + completion state (append-only)

## What automation covers
- topic selection & article drafting
- frontend build (Hugo)
- internal linking / sitemap awareness via topic queue ordering

## Human steps (only these, ~1 hour total, one-time)
1. Choose niche sub-topic and confirm (edit `notes/niche.md`)
2. Buy a domain (€10, Namecheap/Porkbun)
3. Sign up for affiliate programs (see `notes/affiliate-programs.md`)
4. Create a GitHub repo and connect to Cloudflare Pages (free hosting)
5. Approve payout settings

## Verification
- Check `state/queue.json` — article marked `"done"` after generation
- Check `content/` — markdown files with frontmatter
- Run `scripts/build.sh` — should spawn hugo build without errors

## Honesty note
SEO takes 2–4 months for meaningful traffic. Revenue is reported from real affiliate dashboards; agents cannot guarantee numbers.
