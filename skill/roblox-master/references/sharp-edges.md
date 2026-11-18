# Sharp Edges — Skim Before Every Build Phase

| # | Severity | Trap | Fix |
|---|---|---|---|
| 1 | Critical | Player data overwritten/lost on server hop or crash | ProfileStore session locking; kick on load failure |
| 2 | Critical | Client sends price/amount/damage | Server reads values from Catalog/Config only |
| 3 | Critical | ProcessReceipt grants twice or returns Granted before saving | Dedupe by PurchaseId in profile; NotProcessedYet on failure |
| 4 | Critical | Toolbox model with backdoor script | Scan & delete scripts after every `insert_asset` |
| 5 | High | Remote spam / lag exploit | RateLimiter on every remote |
| 6 | High | Memory leaks (connections, player tables) | Trove per player/round; clear on PlayerRemoving |
| 7 | High | `BindToClose` > 30 s or not saving | ProfileStore handles; otherwise parallel saves with cap |
| 8 | High | Studio edits during playtest are lost | Check `get_studio_state`; edit only in Edit mode |
| 9 | High | UI unusable on phones | Scale + constraints + Device Emulator check every screen |
| 10 | High | Game unplayable publicly: no maturity questionnaire | Draft answers in LAUNCH.md; creator submits |
| 11 | Medium | `WaitForChild` infinite yield with StreamingEnabled | Timeouts + handle nil; CollectionService signals |
| 12 | Medium | Module yields at require-time, blocking boot | No yields at top level; do work in Init/Start |
| 13 | Medium | Touched spam (many fires per touch) | Debounce per player + server validation |
| 14 | Medium | `#t` wrong with nil holes | Counters / dictionaries |
| 15 | Medium | Highlight limit (~31 visible) | Use sparingly; SelectionBox/colour alternatives |
| 16 | Medium | Character not loaded when code runs | `player.CharacterAdded` + `WaitForChild("HumanoidRootPart")` |
| 17 | Medium | Tween/animation on server looks choppy | Tween visual objects on clients; server sets final state |
| 18 | Medium | Too many shadowed lights / particles on mobile | Budgets + graphics setting |
| 19 | Medium | `os.time` vs `tick` vs `os.clock` confusion | os.time for dates/days, os.clock for durations, GetServerTimeNow for shared timers |
| 20 | Medium | Unfiltered player text shown to others | TextService filtering |
| 21 | Low | Deprecated `wait/spawn/delay` | `task` library |
| 22 | Low | Lua patterns aren't regex | Use `%` classes, test patterns |
| 23 | Low | Places with same name confuse MCP | Unique place names; record place ID in PROGRESS.md |
| 24 | Low | Generated mesh scale/collision wrong | Check vs 5-stud character, set CollisionFidelity |
| 25 | Critical | Copyrighted names/memes in title, art or audio | Original only; review before launch |
