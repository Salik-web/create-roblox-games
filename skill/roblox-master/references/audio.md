# Audio

## Sources
- Creator Store audio (free, licensed for Roblox use) via `search_asset` (audio).
  Roblox's own licensed music library is safe for experiences. Never upload songs or
  clips you don't own. Uploaded audio is moderated and may have monthly limits.
- Record IDs + purpose in `DECISIONS.md` (AUDIO table).

## Structure
- `SoundService` with `SoundGroup`s: Music, SFX, Ambience, UI, Voice/Stingers.
  Player settings map to group volumes.
- Music: one track per area/state, crossfade (tween Volume) on change; silence is a
  tool (horror). Stingers for wins/losses/unlocks.
- Ambience: looping room tone per area + random one-shots (creaks, drips, birds) at
  random intervals and positions.
- SFX: every interaction (UI click, hover, purchase, collect, footsteps by material,
  door, hit, death, level-up). Slight pitch randomisation (0.9–1.1) to avoid repetition.
- 3D sounds: parent to parts; set `RollOffMode` InverseTapered, `RollOffMinDistance`/
  `Max` sensibly; enemy footsteps/breathing audible before they appear (fair horror).
- Effects: `ReverbSoundEffect`/`EqualizerSoundEffect` on SoundGroups per area
  (cave, hall), `SoundService.AmbientReverb`.

## Horror & comedy audio
- Horror: low drones, heartbeat tied to monster distance, sudden silence before scares,
  distant whispers; stingers short and not deafening (cap volume).
- Meme/comedy: cartoon boings, slide whistles, record scratches, deliberate audio
  "punchlines" timed with visuals. Original or licensed only — no meme songs.

## Mixing
- Music ~0.3–0.5, SFX 0.5–0.8, UI 0.3–0.5. Duck music when stingers/dialogue play.
- Test on phone speakers (thin) and headphones.
