# Scaffold — Starter Framework

Folder paths mirror Studio services. File naming → instance class:
- `*.server.luau` → `Script` (RunContext Legacy) — `Main.server.luau` becomes `Main`
- `*.client.luau` → `LocalScript` — `Main.client.luau` becomes `Main`
- `*.luau` → `ModuleScript` (name = file name without extension)

| File | Studio location |
|---|---|
| ReplicatedStorage/Shared/Config.luau | ReplicatedStorage.Shared.Config |
| ReplicatedStorage/Shared/Net.luau | ReplicatedStorage.Shared.Net |
| ReplicatedStorage/Shared/Signal.luau | ReplicatedStorage.Shared.Signal |
| ReplicatedStorage/Shared/Trove.luau | ReplicatedStorage.Shared.Trove |
| ReplicatedStorage/Shared/RateLimiter.luau | ReplicatedStorage.Shared.RateLimiter |
| ReplicatedStorage/Shared/Format.luau | ReplicatedStorage.Shared.Format |
| ServerScriptService/Main.server.luau | ServerScriptService.Main (Script) |
| ServerScriptService/Services/*.luau | ServerScriptService.Services.* |
| (ProfileStore from GitHub) | ServerScriptService.Packages.ProfileStore |
| StarterPlayerScripts/Main.client.luau | StarterPlayer.StarterPlayerScripts.Main (LocalScript) |
| StarterPlayerScripts/Controllers/*.luau | StarterPlayer.StarterPlayerScripts.Controllers.* |

Install order: folders → Shared modules → ProfileStore → Services → server Main →
Controllers → client Main. Then edit `Config` for the game, playtest, console clean.

Extending:
- New server feature = new ModuleScript in `Services` with `Init(registry)`/`Start()`.
  Access others via `registry.DataService`, etc. Add it to `ORDER` in server Main if it
  must start before others.
- New client feature = new ModuleScript in `Controllers` (same pattern).
- New remote = `Net.Handle("Name", maxPerSecond, handler)` on server,
  `Net.Event("Name")` on client.
- New product = add to `Config.Products` (Grant table for currency, or
  `MonetizationService.RegisterProductHandler(key, fn)` for custom effects).
- New pass perk = add to `Config.GamePasses`; check `MonetizationService.OwnsPass`
  on server or the `Pass_<Key>` player attribute on client.
