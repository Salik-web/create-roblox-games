# Workflow: Build Phase

1. **Prepare**: session start protocol (SKILL.md §1). Read the next unchecked phase in
   `BUILD_PLAN.md`. Skim `references/sharp-edges.md`. Load the references the phase
   needs. If Studio is in play mode, stop the playtest first.
2. **Phase 0 specifics** (setup): rename the place to the game name; set lighting
   technology, avatar type R15, Max Players, StreamingEnabled as per GDD; install the
   `scaffold/` (see `architecture.md` §Scaffold) and ProfileStore; fill `Config`.
3. **Build** each task:
   - Scripts: create instance with the right class via `execute_luau`, write source
     with `multi_edit`, mirror to `games/<slug>/scripts/`.
   - World/UI/VFX: `execute_luau` in chunks with ChangeHistory recordings; generated or
     cleaned store assets per `world-art.md`.
   - Data-driven: content goes into Catalog/Config tables.
4. **Verify** (`testing-qa.md`): playtest the phase's "Done when" scenario, console
   clean, `screen_capture` review of anything visual, phone layout for UI. Fix and
   re-test until it passes. Don't move on with known blockers.
5. **Record**: tick tasks in `BUILD_PLAN.md`; append to `PROGRESS.md` (date, phase,
   what was built, known issues, next step); add any non-obvious choice to
   `DECISIONS.md`; `save_place`; (if git is set up) commit. Then run
   `workflows/learn.md` (capture → log → promote what's verified).
6. **Auto mode**: continue to the next phase. Stop only for: creator-only actions,
   blocked tool, or a decision that costs Robux. Before stopping, leave PROGRESS.md
   so a fresh session resumes exactly.
7. **Report** (≤ 8 lines): phases done, what to look at, creator to-dos, next command.
