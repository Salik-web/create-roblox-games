# Roblox Master — a Claude Code skill for building complete Roblox games

Turn a one-line idea into a designed, built, tested, monetized and launch-ready Roblox
game. Claude Code works directly in your open Roblox Studio through Studio's
**built-in MCP server**.

```
/new-game horror comedy where friends escape a cursed school
/build auto
/polish
/launch
```

## Why it's different
- **Any genre, any experiment.** No fixed genre templates. A universal design method
  plus a catalog of reusable building blocks (rounds, chase AI, hiding, combat,
  building, pets, vehicles, fishing, rhythm, social deduction, tycoon, survival, …).
  New mechanics you invent become new blocks.
- **Self-learning.** Captures new mechanics, tools, bug fixes, visual tricks and data
  results in `LEARNINGS.md`, verifies them, and merges them into the skill.
  `/refresh` checks official Roblox sources for new features and rule changes.
- **Built for the built-in Studio MCP** (2026): scripting, world building, generated
  meshes/materials/avatars/animations, automated playtests, screenshots, and Creator
  Hub actions (game passes, developer products) through Open Cloud permissions.
- **Creator-first.** Every rule is a default you can override; only Roblox policy, the
  law and technical limits are fixed.
- **Organized.** Every game gets a GDD, phased build plan, progress log, decisions log,
  monetization catalog, launch kit and update log. Portfolio, ideas and revenue
  tracking included.

## What's inside
```
skill/roblox-master/
  SKILL.md              router, session protocol, MCP tool map, rules, quality bar
  LEARNINGS.md          the skill's growing memory
  CHANGELOG.md
  references/ (27)      design, mechanics catalog, Luau, architecture, data, security,
                        monetization, economy, retention, UI/UX, world & art, audio,
                        VFX & feel, NPC AI, movement, multiplayer, performance,
                        testing, analytics, policy (2026 age tiers), publishing,
                        DevEx & business, localization, tooling, sharp edges
  workflows/ (15)       new game, ideas, build phase, debug, polish, security,
                        performance, monetization, code review, launch, data review,
                        live update, spin-off, learn, refresh knowledge
  templates/            GDD, BUILD_PLAN, PROGRESS, DECISIONS, MONETIZATION, LAUNCH,
                        UPDATE_LOG
  scaffold/             Luau starter framework: Config, Net (rate-limited remotes),
                        Signal, Trove, Format, server/client bootstraps, ProfileStore
                        DataService, CurrencyService, MonetizationService
                        (idempotent receipts), DailyRewardService, Telemetry
project-template/roblox-games/
  CLAUDE.md             project rules
  .claude/commands/     /ideas /new-game /build /fix /polish /audit /launch /review
                        /update /spinoff /status /learn /refresh
  .claude/settings.json tool permissions
  games/INDEX.md  ideas/IDEAS.md  REVENUE.md  library/
```

## Requirements
- Roblox Studio (latest) with **Assistant → Manage MCP Servers → Enable Studio as MCP server**
- Claude Code connected to Studio (Studio's Quick connect, or the command it shows)
- ProfileStore (fetched automatically during setup from MadStudioRoblox/ProfileStore)

## Install
See [INSTALL.md](INSTALL.md).

## Notes
- Generated games use original content only; Roblox's Community Standards, content
  maturity and publishing rules still apply to whatever you build.
- Roblox APIs and policies change; run `/refresh` regularly. Verify money-related
  numbers (DevEx rates, fees) against official docs.
- The scaffold is a starting point — it is installed and playtested in Studio during
  each game's setup phase.

## Credits
Inspired by [brockmartin/roblox-game-skill](https://github.com/brockmartin/roblox-game-skill).
All content in this repository is original.

## License
MIT — see [LICENSE](LICENSE).
