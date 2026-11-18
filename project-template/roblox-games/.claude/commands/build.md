---
description: Build the next phase(s) of a game in Roblox Studio
argument-hint: [auto] [game-slug]
---
Arguments: $ARGUMENTS

Use the roblox-master skill. Run the session start protocol, then
`workflows/build-phase.md` for the next unchecked phase of the game (slug from the
arguments, otherwise the most recently updated game in `games/`).
If the arguments contain `auto`, keep going phase after phase until the plan is done or
something needs the creator; keep PROGRESS.md current after every phase so a new
session can resume. Verify every phase with a playtest, console check and screenshots
before ticking it. `save_place` after each phase.
