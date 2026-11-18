# Mechanics Catalog — Building Blocks for Any Game

Each block: what it is, key parts, implementation notes, pitfalls. Combine freely.
All authority rules from `networking-security.md` apply to every block.

## Structure & flow
**Lobby → Round loop.** States: Waiting (min players, countdown) → Intermission/Vote →
Loading map (clone from ServerStorage) → Playing (timer, objectives) → Results (rewards,
MVP) → Cleanup (destroy map, reset players). Server state machine; broadcast state +
end time via attribute on `ReplicatedStorage` (`RoundState`, `RoundEndsAt` using
`workspace:GetServerTimeNow()`). Handle joins mid-round (spectate or join), leaves,
last-player-standing, 1-player servers (bots or solo mode).

**Map voting.** 3 random maps, vote pads or UI, ties random. **Mode voting** same.

**Levels/stages (linear).** Checkpoint parts tagged `Checkpoint` with `Stage`
attribute; server verifies order; save best stage; stage select for reached stages;
skip-stage product.

**Chapters/story.** Sequence of scenes with objectives; cutscenes (camera tweens +
dialogue); save chapter; replay with collectibles.

**Procedural generation.** Seeded `Random`; room/tile kits in ServerStorage with
attachment-based connectors; validate connectivity; spawn loot/enemies by tables.
Great for replayability with small art budgets.

**Open world/hub.** Zones with streaming; teleport pads; unlock gates by
progress/currency; points of interest every ~30 s of travel.

**Instanced/private runs.** `TeleportService:ReserveServer` + `TeleportAsync` for party
runs; return to lobby place. (See `multiplayer-social.md`.)

## Player verbs
**Interaction (ProximityPrompt).** Default for doors, items, NPCs, shops, hiding spots.
Server handles `Triggered`, re-validates. Custom prompt UI style via `Style = Custom`.

**Pickups/collectibles.** Tagged parts; client-side visual collect + server validation
by distance; respawn timers; magnet radius upgrade; collection book (meta goal).

**Tools & items.** `Tool` instances or custom equip system (better control, works with
mobile). Hotbar UI, equip remote, server-side use validation, cooldown UI.

**Combat (melee/ranged/magic).** Hitbox via spatial query on server at attack time
(`GetPartBoundsInBox` in front of the root) or server raycasts; damage table in Catalog;
i-frames; knockback via `ApplyImpulse` on server-owned or `LinearVelocity`; hit-stop and
VFX on client. Combos via input buffer. PvE first; PvP needs fairness review.

**Throwing/physics toys.** Spawn server-owned projectile, `ApplyImpulse`, set network
owner to server, cleanup after N seconds. Pool for performance.

**Building/placement.** Grid snapping, rotation, collision check (`GetPartsInPart`),
plot ownership, budget per plot, save layout as compact data
(`{id, x, y, z, rot}` lists), undo, mobile-friendly placement UI.

**Crafting/cooking.** Recipes table (inputs → output, time), stations with queues,
quality from mini-game timing, discovery book.

**Hiding/stealth.** Hide spots (closets, lockers) via ProximityPrompt; server marks
`Hidden` attribute; AI perception ignores hidden unless it saw you enter; breath/noise
mini-game for tension.

**Stamina/sprint/crouch.** Client input, server-authoritative WalkSpeed changes with
stamina tracked server side (or validated); FOV + footstep changes for feel.

**Mini-games.** QTE, timing bar, memory, rhythm, aiming. Reusable `MiniGame` client
module + server result validation (time windows, not trust).

**Vehicles.** Prefer `VehicleSeat` + constraints (HingeConstraint/CylindricalConstraint
for wheels) or custom `LinearVelocity`/`AlignOrientation` controller for arcade feel.
Spawner with ownership; despawn when empty; network owner = driver.

**Fishing / gathering / farming.** Cast → wait (random) → bite → mini-game → loot
table by area/rod/bait; growth timers that continue offline (store timestamps).

**Idle/AFK earnings.** Store `LastSeen`; on return grant capped offline earnings; idle
machines produce per second on server tick (aggregate per player, not per part).

**Pets/companions.** Follow with `AlignPosition`/`AlignOrientation` or client-side
smoothed CFrame (server stores ownership/stats only); equip slots; free hatching from
in-game currency by default (paid hatching only if the creator wants it, with odds shown — see monetization.md); fusing/leveling; show-off value.

**Social deduction / roles.** Server assigns roles secretly; per-player remotes reveal
only their own role; voting UI; meeting timers; proximity voice friendly.

**Racing/obby timing.** Server start time, checkpoints, finish validation, personal
best + global leaderboards, ghost replay (record client positions at 10 Hz for local
display only).

**Sports/ball games.** Server-owned ball physics, possession rules, goals as tagged
regions, team balancing, short matches.

**Rhythm/music.** Beat map timings from `Sound.TimePosition`, client judgement, server
accepts score within plausible bounds.

**Tycoon.** Plot claim, droppers/conveyors (simulate value on server, visual parts
client-side to save performance), buy buttons in dependency order, rebirth.

**Simulator.** Click/tool action → resource; capacity → sell; upgrades → areas;
rebirths; pets. Keep server per-player accumulation numeric, visuals client-side.

**Survival.** Hunger/health meters, day/night cycle (Lighting.ClockTime tween), resource
nodes, crafting, base defense waves.

**Tower defense.** Path waypoints, wave tables, tower placement validation, targeting
modes, server sim at ~10 Hz with client interpolation.

**Roleplay/hangout.** Jobs with small loops, housing/customisation, emotes, props,
vehicles. NOTE: Roblox Kids/Select tiers don't allow social hangout or free-form drawing
games — design these for the 16+ tier.

## Systems around play
**Quests/missions.** Data-defined: type (collect/kill/reach/use), target, count,
reward; daily/weekly rotation by day number; progress via game events bus.

**Achievements/badges.** `BadgeService:AwardBadge` (server, pcall, check
`UserHasBadgeAsync` first). Badges are created in Creator Hub by the creator.

**Collections/codex.** Discover enemies/items/endings; completion rewards; huge for
retention and completionists.

**Inventory.** Dictionary keyed by item ID with counts/metadata; capacity; sorting UI;
equip slots; server-only mutations.

**Shops.** Catalog-driven UI; currency and Robux tabs; preview (3D viewport via
`ViewportFrame` or in-world mannequin); "owned/equipped" states.

**Cosmetic equip.** Skins applied server-side (`HumanoidDescription`,
accessories, or character model swap), so others see them; trails/auras as attachments.

**Spectate/death.** Death screen with cause, revive offer, spectate living players
(camera subject cycling), quick respawn.

**Leaderboards.** In-server (leaderstats) + global (OrderedDataStore), weekly resets.

**Tutorial/onboarding.** Contextual arrows/beams to objectives, short text, input-
specific prompts (touch/keyboard/gamepad), skip for returning players.

**Settings.** Music/SFX volume, sensitivity, graphics quality toggle (reduce VFX),
reduce flashing/scares, saved in profile.

**Codes.** Redeemable codes (server table + expiry) — promote via socials; free only.

**Events bus.** Server-side `Signal` hub (`PlayerEarned`, `EnemyKilled`,
`StageReached`) so quests/achievements/telemetry subscribe without coupling.

## Discovered blocks
New mechanics invented or proven in the creator's games get added here (via
`workflows/learn.md`) using the format below, with the game they came from.

| Block | Summary | From game | Status (tested / proven by data) |
|---|---|---|---|

## Designing a new block
Write in `GDD.md`: Purpose • Player inputs • Rules (server) • Feedback (client) • Data
saved • Remotes • Edge cases (leave mid-action, death, lag, exploit) • Tuning values in
Config • Test steps.
