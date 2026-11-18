# Workflow: New Game (idea → full design → plan)

Input: a vague idea (any genre/hybrid/experiment). Output: a complete game folder,
ready for `/build`. No questions unless a decision costs the creator money.

1. **Expand the idea** with `references/game-design.md`: fantasy, feelings, hook,
   loops, building blocks from `mechanics-catalog.md`, hypothesis. Generate 3
   directions internally, score each with the validation rubric, pick the best (note
   the others in `DECISIONS.md` as alternatives).
2. **Name it**: short, searchable, original. Slug = kebab-case. Check the name isn't an
   existing famous game or brand.
3. **Create** `games/<slug>/` from `templates/`:
   `GDD.md`, `BUILD_PLAN.md`, `PROGRESS.md`, `DECISIONS.md`, `MONETIZATION.md`,
   `LAUNCH.md`, `UPDATE_LOG.md`, folders `scripts/`, `backups/`, `media/`.
4. **Write the GDD** fully (every section in the template). Pull in:
   `narrative.md` (story, characters, tone), `world-art.md` (art direction, palette,
   lighting per area), `audio.md`, `ui-ux.md` (screens + theme),
   `economy-progression.md` (faucets/sinks/curves with numbers),
   `monetization.md` (full catalog with prices + placement),
   `retention-liveops.md` (day-1 tools, 4-week update roadmap),
   `policy-compliance.md` (target label, risks).
5. **Write BUILD_PLAN.md**: phases sized for one session each, every task concrete,
   every phase with a "Done when" test. Standard phase order (adapt freely):
   0 Setup (place, settings, scaffold install) → 1 Core loop greybox playable →
   2 Main systems → 3 Content (levels/enemies/items) → 4 World art & lighting →
   5 UI/UX → 6 Monetization → 7 Audio & feel → 8 Retention & progression →
   9 Polish & performance & mobile → 10 Security/QA → 11 Launch prep.
6. **Write MONETIZATION.md** (table: name, type, price, description, icon idea,
   where offered, ID column empty) and the LAUNCH.md skeleton.
7. **Register** the game in the project `games/INDEX.md` (portfolio table).
8. **Reply** in ≤ 12 lines: name, pitch, hook, core loop, monetization list with prices,
   what Studio place to open (new Baseplate, renamed to the game name), next command:
   `/build auto`.
