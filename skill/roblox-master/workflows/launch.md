# Workflow: Launch Prep

1. Run `security-audit.md`, `performance-audit.md` (quick), full regression checklist
   from `testing-qa.md`. All blockers fixed.
2. **Passes & products**: compare `Config` with `MONETIZATION.md`. For ID 0 entries:
   - If the place is published and the creator enabled MCP Permissions scopes
     (`game-pass:*`, `developer-product:*`), show the final list and ask for a "yes",
     then create via `open_cloud_invoke` and write IDs into Config + MONETIZATION.md.
     Remind them to disable those scopes afterwards.
   - Otherwise: numbered Creator Hub steps (Creations → game → Monetization → Passes /
     Developer Products → Create) with exact name, price, description, icon idea; they
     paste IDs back; you update Config.
   - Badges: creator creates in Creator Hub (not available via MCP); you wire IDs.
3. **Store assets**: icon + 3–5 thumbnails staged and captured (`publishing-growth.md`);
   pass/product icons; upload via `upload_image`/`open_cloud_invoke` thumbnails if
   enabled, else save captures to `media/` for the creator.
4. **LAUNCH.md**: title (+3 alternatives), description, genre, Max Players, audience
   tier, maturity questionnaire draft answers, social clip plan (5 clips), codes,
   week 1–4 update roadmap.
5. Turn off debug features (`Config.Debug` false outside Studio), ProfileStore not
   mocked, Studio API access enabled, allow copying off.
6. `save_place`; ask the creator to also File → Save to File into `backups/`.
7. Creator checklist reply: Publish → Game Settings → Questionnaire → Icon/Thumbnails →
   (Passes/Products if manual) → friends-only test → Public → post first clip.
8. Update `games/INDEX.md` status = Live with date.
