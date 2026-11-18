# Luau Essentials

## Style
- `--!strict` on every module where practical; `--!nonstrict` only when an API's types
  fight you. Annotate public function params/returns and exported types.
- `local Players = game:GetService("Players")` at top; never `game.Players`.
- PascalCase for modules/services/types, camelCase for locals/functions, UPPER_SNAKE for
  constants. Files named after the thing they return.
- One responsibility per module. Return a table (service) or a class constructor.
- Early returns over deep nesting. No globals. No `_G`/`shared` for state.

## Types
```lua
export type Item = { id: string, name: string, price: number, rarity: "Common" | "Rare" | "Epic" }
type Callback = (player: Player, amount: number) -> ()
local function clamp01(x: number): number return math.clamp(x, 0, 1) end
```
- Use `typeof(x) == "Instance"` / `x:IsA("BasePart")` for runtime checks.
- Type casts: `(value :: any) :: Foo` only at boundaries (remotes, DataStore loads).

## Task library (never wait/spawn/delay)
```lua
task.wait(0.5)              -- yields
task.spawn(fn, ...)         -- run now in new thread
task.defer(fn, ...)         -- run at end of current resumption cycle
task.delay(2, fn, ...)      -- run later
local thread = task.delay(5, fn); task.cancel(thread)
```

## Events & cleanup
- Every `:Connect()` that outlives its owner must be disconnected. Use the scaffold
  `Trove` (or Maid) per player / per round / per UI screen and `:Destroy()` it.
- `Instance:Destroy()` disconnects that instance's own events.
- Prefer `:Once()` for one-shot listeners. `:Wait()` yields until fired.
- Signals between modules: scaffold `Signal` (pure Luau) instead of BindableEvents.

## OOP pattern
```lua
local Enemy = {}
Enemy.__index = Enemy
export type Enemy = typeof(setmetatable({} :: { model: Model, health: number }, Enemy))
function Enemy.new(model: Model): Enemy
	return setmetatable({ model = model, health = 100 }, Enemy)
end
function Enemy.Damage(self: Enemy, n: number) self.health -= n end
return Enemy
```

## Tables
- `#t` is unreliable with nil holes — use counters or `table.remove`.
- `table.clone` (shallow), write a `deepCopy` for templates/defaults.
- `table.freeze` config tables to catch accidental writes.
- Dictionaries iterate in undefined order; sort keys for deterministic UI.

## Strings & numbers
- Lua patterns, not regex (`%d`, `%a`, `%s`, `-` lazy). `string.format("%.1f", x)`.
- Abbreviate big numbers for UI (1.2K, 3.4M, 5.6B…) with a shared formatter.
- Integers above 2^53 lose precision; for huge simulator numbers store mantissa/exponent
  or use a BigNum module.
- `math.random` is fine; use `Random.new(seed)` for reproducible procedural generation.

## Error handling
- Wrap every yielding web call (DataStore, MarketplaceService, MessagingService,
  TeleportService, HttpService, GetUserThumbnailAsync, etc.) in `pcall` with retries
  and backoff. Log with context: `warn(("[DataService] load failed for %d: %s"):format(userId, err))`.
- `xpcall(fn, debug.traceback)` when you want the stack.
- Never let one player's error break the server loop: isolate per-player work in
  `task.spawn` + pcall.

## Performance idioms
- Cache services and frequently used instances in locals.
- Avoid `FindFirstChild` chains inside hot loops; cache references.
- Use `workspace:GetPartBoundsInBox/Radius`, `workspace:Raycast` with `RaycastParams`,
  `OverlapParams` instead of Touched for precise detection.
- `RunService.Heartbeat` (server/client), `RenderStepped`/`BindToRenderStep` (client
  camera/visual only, keep it tiny). Prefer events/timers over per-frame polling.
- `CollectionService` tags + `GetInstanceAddedSignal` to drive behaviour for many
  objects (kill bricks, coins, doors) with one script.
- Attributes (`SetAttribute`/`GetAttributeChangedSignal`) for small replicated state.

## Useful built-ins to remember
`TweenService`, `CollectionService`, `PathfindingService`, `ContextActionService`,
`UserInputService`, `GuiService`, `SoundService`, `TextChatService`, `BadgeService`,
`MarketplaceService`, `PolicyService`, `LocalizationService`, `AnalyticsService`,
`MemoryStoreService`, `MessagingService`, `TeleportService`, `SocialService`,
`AvatarEditorService`, `HapticService`, `VRService`, `Debris` (prefer task.delay + Destroy).
