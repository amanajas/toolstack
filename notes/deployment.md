# Deployment

Target: **https://toolstack.page** via GitHub Pages (free, HTTPS auto).

## One-time human steps (only these)
1. Squarespace → toolstack.page → DNS → add (delete any parking records):
   - A @ → 185.199.108.153
   - A @ → 185.199.109.153
   - A @ → 185.199.110.153
   - A @ → 185.199.111.153
   - CNAME www → amanajas.github.io
2. GitHub Pages custom domain will then provision its certificate automatically (agent verifies).

## What automation does
- On push to main: GitHub builds Hugo → deploys to Pages.
- Daily 06:00 cron: scripts/daily.sh generates 1 article (GX10), commits, pushes.

## Interim URL
https://amanajas.github.io/toolstack/ — redirects to the custom domain once DNS + certificate are set.
