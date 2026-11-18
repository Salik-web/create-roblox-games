# Roblox Games — Project Rules

This folder is the creator's Roblox game studio. Every game here is designed, built,
tested and launched by Claude Code using the **roblox-master** skill and the built-in
Roblox Studio MCP server (`Roblox_Studio`).

## Always
- Load the `roblox-master` skill for any Roblox work and follow its session start
  protocol, routing table, non-negotiables and quality bar.
- Use the built-in `Roblox_Studio` MCP tools in the open Studio session. If another
  Roblox skill is installed, this project uses roblox-master's rules; ignore other
  skills' MCP mode detection.
- Make decisions yourself. Ask only when it costs Robux, needs the creator's account
  (publishing, ID verification, Creator Hub permissions), or is irreversible.
- Keep replies short: what was done, what to check, creator to-dos, next command.
- **Nothing in the skill limits the creator.** Every rule except Roblox's own policies,
  the law and technical limits is a default the creator can override. Do it their way,
  mention a real risk once, log the override in the game's DECISIONS.md.
- **Keep learning.** After every phase, fix, review or update, run the skill's
  `workflows/learn.md`. When the creator says "remember this" or invents something new,
  add it to the skill (LEARNINGS.md → promote into the right file).

## Folder conventions
```
CLAUDE.md                 -- these rules
games/
  INDEX.md                -- portfolio: every game, status, key metrics
  <slug>/
    GDD.md BUILD_PLAN.md PROGRESS.md DECISIONS.md
    MONETIZATION.md LAUNCH.md UPDATE_LOG.md
    scripts/              -- mirror of every script in Studio (same hierarchy)
    backups/              -- .rbxl place backups (creator: File → Save to File)
    media/                -- icon/thumbnail captures, analytics exports, clips notes
ideas/IDEAS.md            -- idea backlog with scores
library/                  -- reusable systems extracted from past games
REVENUE.md                -- monthly Robux/DevEx log
```
- Slugs are kebab-case. Dates are YYYY-MM-DD. Tables over prose in docs.
- A new game always gets the full doc set from the skill's `templates/`.
- Update `games/INDEX.md` whenever a game changes status.

## Commands (in .claude/commands)
| Command | Use |
|---|---|
| `/ideas [theme]` | Generate and score new game ideas into ideas/IDEAS.md |
| `/new-game <idea>` | Idea → full design docs + build plan |
| `/build [auto] [slug]` | Build next phase (auto = keep going until done) |
| `/fix <problem>` | Debug or change something |
| `/polish [focus]` | Visual/audio/feel/UX quality pass |
| `/audit [security\|performance\|monetization\|code]` | Run an audit |
| `/launch [slug]` | Final QA + everything needed to publish |
| `/review [slug]` | Post-launch data review: scale, fix or kill |
| `/update <idea>` | Plan and build a live update |
| `/spinoff <twist>` | New game variant from an existing one |
| `/status` | Portfolio overview and what to do next |
| `/learn [thing]` | Teach the skill something / capture recent learnings |
| `/refresh` | Check Roblox for new features & rule changes, update the skill |
