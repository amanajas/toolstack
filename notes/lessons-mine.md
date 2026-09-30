# Lessons the user asked me to keep (persistent)

Written 2026-09-30 at the user's explicit request.

1. **No fake results. If something isn't solved, SAY SO — plainly, with facts.** Never report success on partial verification.
2. **"Finished" means exercised, not built.** I claimed the site was live after checking only the homepage status code; internal links were all broken (pointing at a domain with no DNS). The user checks the links — verifying one endpoint does not verify a surface. For anything clickable, click/read it; for pages, fetch every link target.
3. Broken-link root cause: `baseURL` vs deploy subpath. Rule: when deploying on a subpath, use `relativeURLs = true` and never emit absolute `baseURL` links in layouts.
4. User preferences standing: local GX10 model, not Claude; only minimal human steps; no purchases/registrations without explicit approval; project work confined to the project folder.
