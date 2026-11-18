# Built-in Roblox Studio MCP — Operating Guide

Studio ships its own MCP server (Assistant → … → Manage MCP Servers → Enable Studio as
MCP server). The creator's client registers it as `Roblox_Studio`. Tool names below are
the built-in server's. If a tool is missing, list the available tools and adapt — tool
sets change between Studio versions. Use `submit_feedback` when a tool misbehaves.

## Sessions
- `list_roblox_studios` → every connected Studio with name, instance ID and place ID.
  Every other call needs a `studio_id`. If several are open, match the place name/ID
  recorded in the game's `PROGRESS.md`. Unpublished places show by name only — ask the
  creator to give each place a unique name.
- `get_studio_state` → current play state and available datamodel types
  (`Edit`, `Client`, `Server`). Check before editing: edits during a playtest are lost.

## Reading the place
- `search_game_tree` — filter by path, class or keyword. Start broad
  (`game.Workspace`, `game.ServerScriptService`, `game.ReplicatedStorage`), then narrow.
- `inspect_instance` — properties, attributes, children summary.
- `script_search` (fuzzy name, ≤10 results), `script_grep` (text, ≤50 matches),
  `script_read` (whole script or a line range).
- `subagent` type `explore` — delegate big surveys ("map every RemoteEvent and its
  handler") to keep your context small.

## Writing scripts
- `multi_edit` (Edit datamodel only) applies several edits to one script and **creates
  the script if the path doesn't exist**. Paths use dot notation, e.g.
  `game.ServerScriptService.Services.DataService`.
- Script class comes from where/how you create it. To guarantee the right class
  (Script / LocalScript / ModuleScript) and `RunContext`, create the empty instance first
  with `execute_luau`, then fill it with `multi_edit`:
  ```lua
  local s = Instance.new("ModuleScript")
  s.Name = "DataService"
  s.Parent = game.ServerScriptService.Services
  ```
- Keep one module per file-sized responsibility. After writing, mirror the source into
  `games/<slug>/scripts/<Service>/<Path>.luau` on disk (organized backup + git history).

## Building the world: `execute_luau`
Everything that isn't a script — parts, models, folders, lighting, terrain, attributes,
UI instances, sounds — is created by running Luau in the Edit datamodel.
- Wrap big builds in `ChangeHistoryService` recordings so the creator can undo:
  ```lua
  local CHS = game:GetService("ChangeHistoryService")
  local id = CHS:TryBeginRecording("Build lobby")
  -- ... create instances ...
  if id then CHS:FinishRecording(id, Enum.FinishRecordingOperation.Commit) end
  ```
- Build in chunks (one area / one UI screen per call). Return a short summary string
  (counts, names) so you can verify without inspecting everything.
- Name everything. Group in Models/Folders. Anchor static geometry. Set `CanCollide`,
  `CanQuery`, `CanTouch`, `CastShadow` deliberately (performance + gameplay).
- Use helper functions inside the snippet (makePart, makeModel) for consistency.
- Deterministic layouts: compute positions from a grid/spline instead of hand-placing.
- In `Server`/`Client` datamodels during a playtest, `execute_luau` is for inspection
  and test automation (e.g. give currency to test a shop), not permanent changes.

## Generating art
- `generate_mesh` — textured 3D mesh from a text prompt. Use for hero props, unique
  furniture, creatures, statues. Prompt: object, style, palette, condition, scale hint.
- `generate_material` — custom MaterialVariant (e.g. "cracked green bathroom tiles,
  grimy grout"). Apply via `MaterialService` + `Part.MaterialVariant`.
- `generate_procedural_model` + `wait_job_finished` — models from primitives with
  configurable attributes (buildings, shelves, fences, stairs).
- `generate_avatar` — rigged R15 character from a prompt: NPCs, monsters, mascots.
- `generate_animation` — R15 animation from a prompt (≤10 s) or R6→R15 conversion:
  idle, walk, attack, emote, jump-scare lunge, dance.
- Always: check scale against a 5-stud-tall character, set anchoring/collision, give it a
  clear name, store reusable ones in `ServerStorage/Assets` or `ReplicatedStorage/Assets`.
- Generation may be rate-limited; if a job fails, retry once with a simpler prompt,
  otherwise fall back to `search_asset` or a primitive build.

## Using Creator Store assets
- `search_asset` → candidates; prefer high-rated, from known creators, script-free.
- `insert_asset` by ID, then immediately `search_game_tree` the inserted model for any
  `Script`, `LocalScript`, `ModuleScript`. Read them. Delete anything with `require(`
  of a numeric ID, `getfenv`, `setfenv`, `loadstring`, obfuscated strings, HttpService,
  `MarketplaceService` prompts, or `TeleportService` calls you didn't ask for.
- `upload_image` (from URLs) / `store_image` (local files) for decals, UI icons,
  thumbnails. Uploaded images go through moderation; keep them original.

## Testing loop
1. `save_place` (cheap insurance).
2. `start_stop_play` to start.
3. Drive it: `character_navigation` to a target, `user_keyboard_input`
   (WASD, Space, E, Shift), `user_mouse_input` (clicks on UI). Or delegate a scripted
   scenario to `subagent` type `playtest` ("join, buy item in shop with test coins,
   equip it, die to monster, respawn; report errors").
4. `get_console_output` — any error/warning you caused must be fixed.
5. `screen_capture` — look at it. Is it readable, lit well, on-style? Capture from
   custom camera positions for overview shots of each area.
6. `start_stop_play` to stop. Fix in Edit mode. Repeat.
Multi-client and full-server tests are covered in `testing-qa.md`.

## Creator Hub actions via Open Cloud (`open_cloud_invoke`)
Possible through MCP **if the creator enables the scopes** (MCP button bottom-right of
Studio → MCP Permissions, or Assistant → … → Settings → MCP Permissions):
- Game passes (`game-pass:*`) — create/edit name, description, price, icon.
- Developer products (`developer-product:*`).
- Experience settings (`universe:write`).
- Thumbnails (`universe.thumbnail:*`).
Not possible: badges (use Creator Dashboard). Place must belong to a **published** game.
Some endpoints may still reject the Studio token (401/403) → give the creator manual
steps instead. These scopes are high-risk: ask the creator to enable them only for the
setup step and disable afterwards. Always show the full list (names, prices) and get a
"yes" before creating anything that is sold for Robux.

## Docs
`http_get` reaches official Roblox docs (create.roblox.com). When unsure of an API's
exact name, signature or limits, look it up instead of guessing. The `skill` tool returns
Roblox's own best-practice notes for topics like debugging or device simulation.

## Safety
- Connected clients can read and modify open places. Only this project's Claude Code
  session should be connected.
- Never publish (that's the creator's click). `save_place` saves; it doesn't publish.
