# Deployment

Target: **https://soundfrequency.online** via GitHub Pages (free, HTTPS auto).

## One-time human steps (only these)
1. Squarespace → soundfrequency.online → DNS settings → add these records (for GitHub Pages apex):
   - A @ 185.199.108.153
   - A @ 185.199.109.153
   - A @ 185.199.110.153
   - A @ 185.199.111.153
   - CNAME www → amanajas.github.io
2. GitHub Pages setting is done by the workflow; the custom domain check under Settings→Pages appears after DNS propagates (can take up to ~24h, usually <1h).

## What automation does
- On push to `main`: GitHub builds Hugo and deploys to Pages.
- Locally: `bash scripts/build.sh` regenerates one article + builds; commit+push goes through the agent afterwards.

## Interim URL before DNS
The site is reachable at `https://amanajas.github.io/<repo>/?` — custom domain config is set once DNS records are added (a `CNAME` file is included in the repo root for this).
