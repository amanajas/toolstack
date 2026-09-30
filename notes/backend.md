# LLM backend options

`scripts/generate_article.sh` uses `LLM_BACKEND`, default `claude-cli`.

## Status 2026-09-30

| Backend | State | Fix |
|---|---|---|
| claude-cli | 401 OAuth token revoked | run `claude login` in a terminal |
| ollama | system service crash-loops: OLLAMA_MODELS points at /media/ta/Games/jasmin/.ollama, Games disk not mounted | mount the Games disk (host-level fix, outside this project); models also missing blobs (du 48K) — after mount, `ollama pull` the model named in the script if still absent |
| gemini | CLI installed but unauthenticated | run `gemini` once and follow the auth prompt (needs a Google AI API key locally) |

To use a working backend:
```
LLM_BACKEND=claude-cli bash scripts/build.sh   # or ollama once the service is healthy
```

To automate daily generation once a backend works:
```
crontab -e
0 6 * * * /bin/bash /home/ta/projects/toolstack/scripts/build.sh >> /home/ta/projects/toolstack/state/cron.log 2>&1
```

Honest note: no backend on this box currently produces text from a script. Until one is fixed, the pipeline still builds and deploys; the parent agent can write articles manually.
