# Data Persistence

## Default: ProfileStore (session locking)
ProfileStore (MadStudioRoblox, successor of ProfileService) prevents data loss when a
player server-hops, teleports or a server crashes, and handles autosave and shutdown.
The scaffold `DataService` wraps it. Key API (verify against the module's docs when
installing — read its header comments):
```lua
local ProfileStore = require(ServerScriptService.Packages.ProfileStore)
local Store = ProfileStore.New("PlayerData_v1", TEMPLATE)
local profile = Store:StartSessionAsync(`Player_{player.UserId}`, {
	Cancel = function() return player.Parent ~= Players end,
})
if profile then
	profile:AddUserId(player.UserId)   -- GDPR
	profile:Reconcile()                 -- fill missing fields from TEMPLATE
	profile.OnSessionEnd:Connect(function() player:Kick("Data session ended, rejoin.") end)
	if player.Parent == Players then -- keep it
	else profile:EndSession() end
else
	player:Kick("Couldn't load your data, please rejoin.")
end
-- on PlayerRemoving: profile:EndSession()
```
- `Store.Mock` in Studio for tests that must not touch real data (toggle in Config).
- Studio needs **Game Settings → Security → Enable Studio Access to API Services** (place
  must be published) for real DataStores in playtests.

## Schema
```lua
TEMPLATE = {
	Version = 1,
	Currencies = { Coins = 0, Gems = 0 },
	Inventory = { Skins = { Default = true }, Items = {} },
	Equipped = { Skin = "Default" },
	Progress = { Level = 1, XP = 0, Chapter = 1, BestTime = 0 },
	Stats = { Plays = 0, Deaths = 0, Wins = 0, PlaytimeSeconds = 0 },
	Daily = { LastClaimDay = 0, Streak = 0 },
	Quests = {},
	Purchases = { Receipts = {}, TotalRobuxSpent = 0 }, -- ProcessReceipt dedupe log
	Settings = { Music = 0.5, Sfx = 0.8, Sensitivity = 1 },
	Flags = {},  -- tutorial done, first purchase, etc.
}
```
- Use dictionaries keyed by ID (`Skins = { Ninja = true }`), not arrays, for owned sets.
- Bump `Version` and write a migration function for breaking changes; `Reconcile`
  handles additive changes.
- Keep receipts log bounded (last ~100 PurchaseIds).
- Keep profiles small (< ~100 KB). Large per-player worlds (building games) go in a
  separate key/store, compressed (serialize to compact strings).

## Leaderboards (OrderedDataStore)
- Separate OrderedDataStore per stat ("Wins_AllTime", `"Wins_Week_" .. weekNumber`).
- Write on change, throttled (e.g. every 60 s per player + on leave). Integers only.
- Read top N with `GetSortedAsync(false, 50)` every 60–120 s on one server loop and
  render on a SurfaceGui board + UI. Resolve names with `Players:GetNameFromUserIdAsync`
  (cached, pcall). Weekly boards reset by key name, no deletion needed.

## Cross-server
- **MessagingService**: global announcements, live events, cross-server shout. Small
  payloads, best-effort, rate limited.
- **MemoryStoreService**: queues (matchmaking), sorted maps (live leaderboards, server
  browser), short-lived shared state with expiry. Not for permanent data.
- **DataStore (non-player)**: global counters (total wins), config set by you.

## Budgets & failure
- DataStore requests have per-server budgets; check
  `DataStoreService:GetRequestBudgetForRequestType` before bursts.
- Retry with exponential backoff (1, 2, 4 s…), max ~5 tries; never retry in tight loops.
- On load failure: kick with a friendly message rather than letting them play on
  default data (which would overwrite real data later).

## Fallback (no ProfileStore)
If ProfileStore can't be installed: one `UpdateAsync` per save, store
`{ data, lock = { jobId, time } }`; on load, if lock is held by another live server
(< 5 min old) wait/retry up to ~30 s; release on leave; autosave every 120 s; save all
in `BindToClose` with parallel `task.spawn` and a 25 s cap. Document the risk in
`DECISIONS.md` and replace with ProfileStore when possible.

## Testing data
- Test: join, earn, leave, rejoin → values persist. Two Studio test servers for
  session-lock behaviour. Shutdown during save. Purchase during shutdown.
- Never test with real Robux; Studio purchases are simulated.
