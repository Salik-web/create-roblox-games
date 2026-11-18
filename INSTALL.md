# Install Guide (Windows)

Two parts:
1. `skill/roblox-master/` — the Claude Code skill (knowledge, workflows, templates,
   starter code). Installed once for your user.
2. `project-template/roblox-games/` — your games workspace (rules, commands, portfolio files).

## 1. Install the skill
Copy the folder `skill\roblox-master` to:
```
%USERPROFILE%\.claude\skills\roblox-master
```
(so the file `%USERPROFILE%\.claude\skills\roblox-master\SKILL.md` exists).
Tip: paste `%USERPROFILE%\.claude\skills` into File Explorer's address bar; create the
`skills` folder if it's missing.

## 2. Set up your workspace
Copy `project-template\roblox-games` wherever you keep your games (e.g. `D:\roblox-games`).
If you already have a `roblox-games` folder from before, replace its `CLAUDE.md` and
`.claude` folder with these (keep your `games` folder).
Hidden folders: in File Explorer, View → Show → Hidden items, to see `.claude`.

## 3. Optional
If you installed brockmartin's `roblox-game` skill, you can keep it or delete
`%USERPROFILE%\.claude\skills\roblox-game`. This kit's CLAUDE.md tells Claude to follow
roblox-master's rules either way.

## 4. Check it works
1. Open Roblox Studio, new Baseplate, MCP server enabled.
2. Open cmd in your games folder, run `claude`.
3. Type `/` — you should see /new-game, /build, /status, etc.
4. Ask: "Which skills do you have?" — roblox-master should be listed.

## 5. Make a game
```
/new-game <your idea>
```
Read the GDD it writes, then:
```
/build auto
```
Run `/build auto` again whenever it stops. Then `/polish`, `/audit`, `/launch`.
Teach it anything new with `/learn <thing>`; run `/refresh` monthly for Roblox updates.
Tip: make the skill folder a git repo (`git init` inside it) so every self-update is versioned.
After launch: `/review`, `/update`, `/ideas`, `/status`.

## 6. For game passes/products via Claude (optional)
After the game is published: in Studio click MCP (bottom-right) → MCP Permissions →
enable game-pass and developer-product scopes during `/launch`, then disable them.
