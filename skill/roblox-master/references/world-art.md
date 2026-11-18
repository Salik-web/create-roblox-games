# World Building & Art Direction

## Art direction first
Write in `GDD.md` before building: style (stylized low-poly, realistic, toon, voxel,
retro PS1, cartoon-meme, neon), palette (5–7 hex colours + 1 accent for interactables),
material set, lighting mood per area, 3 reference descriptions. Every asset follows it.

## Lighting presets (set via `execute_luau`; tune per area)
Always: `Lighting.Technology = Enum.Technology.Future` (best quality; ShadowMap if perf
issues), add `Atmosphere`, `ColorCorrectionEffect`, `BloomEffect`, optionally
`SunRaysEffect`, `DepthOfFieldEffect`, `BlurEffect` (UI moments only).

| Mood | Clock / Brightness | Ambient / OutdoorAmbient | Atmosphere | ColorCorrection |
|---|---|---|---|---|
| Horror night | ClockTime 0–2, Brightness 0.5–1 | very dark blue/grey | Density 0.4–0.6, Haze 2–3, dark colour | Saturation −0.3, Contrast 0.2, slight teal/green tint |
| Bright cartoon | ClockTime 13–14, Brightness 2–3 | warm light | Density 0.25, Haze 0 | Saturation 0.2, Contrast 0.05 |
| Sunset cosy | ClockTime 17.6–18 | orange | Density 0.3, Haze 1.5, warm Decay | warm tint |
| Neon city | ClockTime 0, low ambient | purple | Density 0.35, Glare 0.5 | Contrast 0.25, Bloom strong |
| Underground | Exposure −0.5 | near black | dense, short | desaturated |
Indoor horror relies on **local lights**: PointLights/SpotLights with shadows, warm/cold
contrast, flickering scripts, pools of light and darkness to guide the player.

## Building quality checklist
- Scale: doors ~7–8 studs tall, ceilings 10–14, corridors 8+ wide (cameras clip).
- Silhouette & landmarks: each area has one memorable landmark for navigation.
- Detail density: trim pieces, baseboards, frames, pipes, cables, clutter, decals
  (posters, stains, signage), props grouped in believable clusters.
- Material variety: use MaterialVariants (`generate_material`) for hero surfaces.
- Guide the eye: light, colour accent, and paths lead to objectives.
- No large flat untextured planes; break up with trim, colour variation, props.
- Terrain for outdoors (`Terrain:FillBlock/FillBall/FillRegion`, materials, water),
  decorations off for perf where needed. Sky via `Sky` object (generated or store).
- Interiors: modular kit (wall, corner, doorframe, window, floor tile) on a grid →
  fast, consistent, easy to procedurally assemble.

## Asset sources (in order)
1. **Generate**: `generate_mesh` (hero props, creatures, unique furniture),
   `generate_procedural_model` (architecture, shelves, fences), `generate_material`,
   `generate_avatar` (characters), `generate_animation`.
2. **Creator Store**: `search_asset` + `insert_asset`, then script-scan and clean
   (see `mcp-studio.md`). Check licence/usage notes on the asset.
3. **Primitive build**: parts/unions/wedges with good materials — fine for stylized.
Keep a per-game `Assets` folder; record notable asset IDs in `DECISIONS.md`.

## Sky, weather, time
- Day/night cycle: tween `ClockTime`; switch lights at dusk; event-based fog changes.
- Rain/snow: client particle emitter around camera; sound loops; wet materials.
- Wind: `workspace.GlobalWind` affects particles/grass.

## Visual verification
After each area: `screen_capture` from 3–5 camera positions (overview, player eye
level, key moments). Check: readable path, interesting composition, no z-fighting,
no floating props, lighting mood correct, interactables stand out, nothing copyrighted.

## Icons & thumbnails source shots
Set up a "PhotoStudio" model area (hidden from players or in a separate place) with
dramatic lighting to stage characters/items for icon and thumbnail captures.

## Performance
- `StreamingEnabled` for large maps (set `ModelStreamingMode` Atomic for models that
  must load whole). Mesh LOD (`RenderFidelity` Automatic), `CastShadow` off on small
  props, limit lights with shadows (~ a few visible at once), reuse meshes
  (instancing), avoid huge unions.
