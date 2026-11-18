# Architecture & Project Layout

## Standard layout (every game)
```
ReplicatedFirst/
  Loading.client         -- custom loading screen, preloads key assets
ReplicatedStorage/
  Shared/                -- modules both sides use
    Config               -- tunables, IDs, prices, feature flags (frozen table)
    Net                  -- creates/gets RemoteEvents/Functions by name
    Signal, Trove, Format, RateLimiter, Types, Catalog (items/skins data)
  Assets/                -- client-visible models, VFX, sounds, UI templates
  Remotes/               -- created at runtime by Net (server) — don't hand-place
ServerScriptService/
  Main (Script)          -- boots services: Init all, then Start all
  Services/ (ModuleScripts)
    DataService, MonetizationService, CurrencyService, DailyRewardService,
    AnalyticsService (wrapper named Telemetry), <Gameplay>Service...
  Packages/ProfileStore  -- third-party server modules
ServerStorage/
  Assets/                -- server-only models (enemies, maps, loot), cloned on demand
  Maps/                  -- round maps / chapters
StarterPlayer/
  StarterPlayerScripts/
    Main (LocalScript)   -- boots controllers
    Controllers/         -- UIController, InputController, CameraController,
                            EffectsController, AudioController, <Gameplay>Controller
  StarterCharacterScripts/ -- per-character client scripts (sprint, footsteps)
StarterGui/              -- ScreenGuis (ResetOnSpawn = false for persistent UI)
Workspace/
  Map/ (static, anchored), Spawns/, Interactables/ (tagged), Runtime/ (spawned stuff)
```

## Service / controller pattern (no framework dependency)
Each service is a ModuleScript returning a table with optional `Init()` and `Start()`.
`Main` requires all, calls every `Init` (set up state, no yields to other services),
then every `Start` in `task.spawn` (connections, loops). Services reference each other
via `require` inside `Start` or via the shared registry passed to Init.

```lua
-- Service template
local MyService = {}
function MyService.Init(registry) MyService.Registry = registry end
function MyService.Start() end
return MyService
```
Same pattern on the client for controllers. See `scaffold/`.

## Communication
- **RemoteEvent** — client↔server messages. Default choice.
- **UnreliableRemoteEvent** — frequent, loss-tolerant (aim direction, cosmetic effects).
- **RemoteFunction** — client→server request/response only (e.g. "can I buy X?").
  Never server→client InvokeClient (client can hang the server).
- **Attributes** on Player/Character/objects — simple replicated state the client reads
  (coins display, round state, door locked). Server writes, client listens.
- **Value objects in leaderstats** — only for the leaderboard.
- Name remotes by intent: `RequestPurchase`, `RequestEquip`, `RoundStateChanged`.
  Centralize names in `Net` so typos fail loudly.

## State ownership
- Server owns: currencies, inventory, progression, round state, health/damage, spawns,
  ownership, anything others see or that has value.
- Client owns: input, camera, UI state, predicted cosmetic effects, local settings.
- Client prediction for responsiveness (play the swing anim now), server confirms
  (apply damage), client reconciles (show hit marker on confirmation).

## Data-driven design
- Items, skins, enemies, levels, quests, shop entries are **data tables** in
  `Shared/Catalog` (or `ServerStorage` if secret), not hard-coded logic.
- Adding content = adding a row + an asset. This makes updates and spin-offs fast.
- Feature flags in `Config.Features` let you ship code dark and turn it on later.

## Scaffold
`scaffold/` contains ready modules: Config, Net, Signal, Trove, RateLimiter, Format,
Main (server), DataService (ProfileStore), CurrencyService, MonetizationService,
DailyRewardService, Telemetry, Main (client), PurchaseController.
Install at the start of every new game (Phase 1):
1. Create folders/instances with `execute_luau` (right classes: Script, LocalScript,
   ModuleScript). Server `Main` is a `Script` in ServerScriptService; client `Main` is a
   `LocalScript` in StarterPlayerScripts.
2. Write each file's source with `multi_edit`.
3. Install **ProfileStore**: fetch the latest `ProfileStore.luau` from the
   MadStudioRoblox/ProfileStore GitHub repository (WebFetch from Claude Code), put it
   in `ServerScriptService.Packages.ProfileStore`. If unreachable, ask the creator to
   insert it from the Creator Store / download it, or use the fallback described in
   `data-persistence.md`.
4. Fill `Config` for the game; playtest; console must be clean.

## Scaling up
- When a game grows past ~30 modules or gets a teammate, consider Rojo + Git
  (`tooling-external.md`). The built-in MCP workflow keeps working alongside.
- Multiple places in one experience (lobby + matches) share `Shared` code: keep a copy
  per place, sync via packages (Studio Packages, right-click → Convert to Package) so one
  update propagates.
