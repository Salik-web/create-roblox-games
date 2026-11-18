# Networking & Security

Assume exploiters can: fire any remote with any arguments at any rate, read all client
code and ReplicatedStorage, teleport/fly their character, change client-side
properties, delete local UI, and spoof client-side physics on parts they own.

## Remote handler checklist (server side, every handler)
1. **Rate limit** per player per remote (scaffold `RateLimiter`, e.g. 10/s for UI
   actions, 1/s for purchases, 20/s for combat inputs). Drop silently; log abuse.
2. **Type-check** every argument (`typeof`, `type`, NaN check `x ~= x`, `math.huge`,
   string length caps, table depth/size caps). Reject unknown IDs.
3. **Ownership**: does the player own the item/plot/pet they reference?
4. **State**: are they alive, in the right round/area, not already doing it?
5. **Distance/line-of-sight**: are they close enough to the shop/door/NPC/enemy?
   Use server positions (`character.HumanoidRootPart.Position`), small tolerance.
6. **Cooldown**: server-tracked timestamps (`os.clock()`).
7. **Act on the server's own data**, never on client-supplied amounts or prices.
8. Return nothing sensitive; for RemoteFunctions return simple results.

## Never
- Accept `amount`, `price`, `damage`, `reward`, `position to teleport to` from client.
- Put secret logic, admin lists or item drop tables in ReplicatedStorage.
- Use `RemoteFunction:InvokeClient`.
- Trust `Touched` from client-owned parts for rewards — validate on server
  (distance + cooldown + state).
- Use `loadstring` or `require` of asset IDs from untrusted sources.

## Movement & physics exploits
- Characters are client network-owned: speed/fly/teleport hacks are possible.
- Server sanity check (light): sample root position every ~0.5 s; if horizontal speed
  >> WalkSpeed allowance (account for knockback, vehicles, teleports you caused), pull
  back or flag. Avoid false positives — lag spikes exist. Prefer rewards gated by
  server checks over aggressive kicking.
- Checkpoints/finish lines: verify the player passed previous checkpoints in order and
  that minimum time elapsed.
- Set network owner to server (`part:SetNetworkOwner(nil)`) for important physics
  objects (balls, carts, bosses, doors).

## Combat
- Client sends intent (`Attack`, aim direction). Server checks cooldown, weapon owned,
  target within range/cone, raycast from server positions, then applies damage.
- Projectiles: server authoritative or client-visual + server hit validation.

## Purchases
- All Robux purchases through `MarketplaceService` + `ProcessReceipt` (server).
- Currency purchases: server checks price from Catalog, deducts, grants, saves.

## Admin & debug commands
- Admin = hard-coded creator UserId on the server only. Remove debug remotes before
  launch or gate them by `RunService:IsStudio()` + admin check.

## Logging abuse
- Count rejections per player; `Telemetry` custom event on suspicious patterns.
  Kick only for clear-cut cases (e.g. impossible values) — and never for one lag spike.

## Chat & text
- All chat via `TextChatService`. Any player-written text shown to others (pet names,
  signs, plot names) must go through `TextService:FilterStringAsync` and
  `GetNonChatStringForBroadcastAsync` (or user-specific variant) before display.
