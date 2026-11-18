# Workflow: Performance Audit

1. Measure baseline during a playtest via `execute_luau`: instance counts in
   Workspace (parts, meshes, lights with shadows, particle emitters + total rate),
   `Stats` memory, physics FPS, heartbeat time; note per area.
2. Check settings: StreamingEnabled (big maps), lighting technology, shadows.
3. Find hot code: per-frame loops, per-part scripts, frequent remotes, `.Changed`
   listeners, unthrottled raycasts. Consolidate to central loops/CollectionService.
4. Reduce: CastShadow off on small props, merge/instance meshes, decoration collisions
   off, pool effects, cap NPCs, client-side visuals, lower particle rates on Low.
5. Re-measure; record before/after in `PROGRESS.md`.
6. Add/verify the in-game Graphics setting (Low/High).
