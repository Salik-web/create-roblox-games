# Performance

Target: smooth on a low-end Android phone with 4 GB RAM, and server heartbeat ~60 Hz
with a full server.

## Budgets (rule-of-thumb)
- Visible parts: keep the streamed/visible scene in the low thousands on mobile; use
  meshes and instancing instead of thousands of tiny parts.
- Shadow-casting lights visible at once: a handful.
- Particles: modest rates; scale down on low graphics.
- Client memory: watch Developer Console (F9 → Memory); textures and sounds dominate.
- Server: no per-part loops; aggregate per player; ≤ 10 Hz for AI/sim ticks.

## Tools
- MicroProfiler (Ctrl+F6) for frame spikes; Developer Console (F9) for memory, network,
  script activity; Studio "Script Profiler"; `debug.profilebegin/profileend` labels.
- During MCP playtests, run `execute_luau` (Client/Server) to sample
  `workspace:GetRealPhysicsFPS()`, `Stats` service values, instance counts, and log them.

## Techniques
- `StreamingEnabled` for big worlds; Atomic/Persistent model streaming where needed;
  client code must handle parts that aren't streamed yet (`WaitForChild` with timeouts,
  `CollectionService` added signals).
- Anchor static parts; disable `CanTouch`/`CanQuery` on decoration; `CastShadow` off on
  small props; `RenderFidelity` Automatic; collision fidelity Box/Hull for decoration.
- Client-side visuals: spawn effects, coins, droppers' parts, crowds on clients only.
- Object pooling for projectiles, VFX, NPCs.
- Debounce/throttle events; avoid `.Changed` on frequently changing properties;
  use `GetPropertyChangedSignal` for specific ones.
- Remotes: batch updates, send deltas not full tables, `UnreliableRemoteEvent` for
  high-frequency cosmetic data, keep payloads small.
- Memory leaks: Trove per player/round; disconnect on leave; clear tables keyed by
  Player on `PlayerRemoving`.
- Textures: reuse, reasonable resolutions; avoid many unique 1024px decals.
- Graphics setting in game: Low (no post-processing extras, fewer particles, shorter
  render of decorations) / High.

## Load time
Small ReplicatedFirst loading screen; `ContentProvider:PreloadAsync` only the first
area's key assets; stream the rest.
