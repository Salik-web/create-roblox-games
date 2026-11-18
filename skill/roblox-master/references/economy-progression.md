# Economy & Progression

## Currencies
- **Soft currency** (Coins): earned by playing, spent on most things. Infinite faucet.
- **Hard currency** (Gems) — optional: rare drops + Robux packs. Use only if the game
  has enough sinks to justify it; otherwise sell soft currency directly.
- **Event tokens**: temporary, expire with the event (creates urgency).
- **Progress stats** (XP, Rebirths, Prestige) are not spendable.
Keep ≤3 visible currencies.

## Faucets and sinks
List every source (faucet) and every spend (sink) in `GDD.md` with rough per-minute
rates. Healthy economy: a player can afford a meaningful unlock every 3–10 minutes early,
every 15–30 minutes mid, and has aspirational goals that take days.
- Faucets: completion rewards, pickups, kills, daily rewards, quests, AFK/idle gains,
  achievements, friends bonus, group bonus, Premium bonus.
- Sinks: cosmetics, upgrades, unlocking areas, consumables, rerolls (free-currency
  only), rebirth resets, crafting, decorating, trading fees.

## Curves
- Cost of level n: `base * growth^(n-1)` with growth 1.15–1.6 depending on pace;
  reward per action grows slower so each upgrade is felt.
- Prestige/rebirth: reset soft progress for a permanent multiplier (+10–50%). Unlocks
  new content tiers so it never feels like pure loss.
- Diminishing returns where stacking would break balance.
- Use a spreadsheet (or a quick Python script in Claude Code) to simulate time-to-unlock
  for 10/60/300 minutes of play before locking numbers. Record in `DECISIONS.md`.

## Pacing goals by session
| Moment | Player should feel |
|---|---|
| 0–1 min | Instant first reward, clear goal |
| 1–5 min | First upgrade/unlock, first "wow" |
| 5–20 min | Several choices, a mini-boss/milestone, first social moment |
| 20–60 min | Big unlock or chapter end, reason to come back tomorrow |
| Day 2–7 | Daily streak, longer goals, collections, leaderboard climb |

## Multipliers that sell
2x currency pass, Premium bonus (+10–20%), group join bonus (+10%), friends-in-server
bonus, event weekend 2x (server-wide), temporary boosts (product). Display the total
multiplier breakdown in UI.

## Anti-inflation
- Cap AFK earnings (or make them a deliberate idle mechanic).
- Price cosmetics at multiple tiers so rich players still have goals.
- New content each update raises the ceiling.

## Validation
- Every number in `Config`/`Catalog`. No magic numbers in services.
- Telemetry economy events on every earn/spend (`AnalyticsService:LogEconomyEvent`)
  to see real flows after launch, then rebalance.
