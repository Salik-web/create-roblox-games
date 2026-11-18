# Workflow: Spin-off / Variant

Make a new game fast from an existing one (new theme, twist, or mode).
1. Creator duplicates the place file in Studio (File → Save to File, open copy,
   rename place) or starts a new place; confirm with `list_roblox_studios`.
2. Create `games/<new-slug>/` with docs from templates; GDD states the source game,
   what's reused, and what's new (theme, art, twist). Different name, icon, story.
3. Plan: reskin (art direction, lighting, audio, UI theme), swap content tables
   (Catalog), new twist mechanic, fresh monetization items. Change DataStore name
   (`PlayerData_<newslug>_v1`) so data never mixes.
4. Build with `build-phase.md`. Register in `games/INDEX.md` as a variant.
