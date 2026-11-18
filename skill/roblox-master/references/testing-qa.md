# Testing & QA

## Every phase: automated playtest via MCP
1. `save_place`. 2. `start_stop_play`. 3. Drive with `character_navigation`,
`user_keyboard_input`, `user_mouse_input`, or delegate to `subagent` (playtest) with a
written scenario. 4. `get_console_output` → zero new errors/warnings.
5. `screen_capture` key moments. 6. Stop, fix, repeat.

## Test hooks (Studio only)
- `Config.Debug = RunService:IsStudio()` enables: grant currency, set stage, spawn
  enemy, skip timer, simulate purchase. Expose as server functions callable through
  `execute_luau` in the Server datamodel during playtests, never as remotes in live.
- Studio purchases are simulated — test every pass/product flow, including declining
  the prompt and the player leaving mid-purchase.

## Multiplayer tests
Studio Test tab → Clients and Servers → Local Server with 2–4 players (creator runs it
if MCP can't start multi-client). Test: joins mid-round, leaves mid-action, party
teleports, simultaneous purchases, leaderboards, last-player cases.

## Device tests
Device Emulator (phones, tablet, console), touch controls, small-text check, low
graphics. If the creator has a phone, ask them to play the published private/
friends-only version once before going public.

## Unit-style tests (optional, for complex logic)
Pure Luau modules (economy formulas, quest progression, inventory ops) can be tested
with a tiny assertion runner executed via `execute_luau`; keep tests in
`ServerStorage/Tests` (not shipped to clients).

## Regression checklist (before every publish)
- [ ] New player flow: tutorial, first reward, first purchase prompt timing
- [ ] Returning player: data loads, daily reward, equipped cosmetics
- [ ] Each pass: owned on join and bought mid-session
- [ ] Each product: grants once; decline does nothing
- [ ] Death/respawn, round end, server with 1 player
- [ ] Phone layout of every screen
- [ ] Output clean; no debug tools reachable by players
- [ ] Performance sample (FPS, memory) acceptable
- [ ] Data saves on leave and on shutdown

## Bug reports
`PROGRESS.md` → "Known issues" list with severity (Blocker/Major/Minor), steps,
suspected cause. Blockers fixed before publish.
