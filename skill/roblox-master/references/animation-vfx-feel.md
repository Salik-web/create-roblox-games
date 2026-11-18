# Animation, VFX & Game Feel ("Juice")

## Animation
- Generate R15 animations with `generate_animation` (≤10 s): idles, walks, attacks,
  emotes, scares, celebrations. Or convert R6 anims to R15.
- Load once via `Animator:LoadAnimation`, cache tracks, set `Priority`
  (Core < Idle < Movement < Action < Action2–4), `Looped`. Use
  `GetMarkerReachedSignal("Hit")` to sync damage/SFX/VFX to frames.
- Replace default character anims via the `Animate` script values for themed games.
- Emotes: emote wheel UI or `HumanoidDescription:SetEmotes` / `PlayEmote`.

## Particles & effects
- `ParticleEmitter`: Rate low + `:Emit(n)` bursts for impacts; `Lifetime`, `Size`
  and `Transparency` as NumberSequences; `LightEmission` for glow; `Drag`,
  `Acceleration`, `SpreadAngle`; FlipbookLayout for animated textures.
- `Beam` (lasers, flashlight cones, guide arrows), `Trail` (sword swings, speed,
  cosmetics), `Highlight` (outline important objects, but max ~31 visible).
- Recipes to build: impact puff, coin collect sparkle, level-up column, dust on land,
  speed lines, magic aura, smoke, fire, rain, fog wisps, ghost shimmer, confetti.
- Spawn VFX on clients (FireAllClients with position/type) rather than server parts;
  pool and reuse.

## Camera
- Shake (decaying noise offset on `Camera.CFrame` in RenderStepped), FOV punch on sprint
  and impacts, slight tilt on strafe (subtle), zoom on reward reveal, cinematic
  cutscenes by tweening `Camera.CFrame` with `CameraType = Scriptable`, letterbox bars.
- Respect a "reduce camera motion" setting.

## Hit feedback stack (combat/impacts)
Anticipation (windup) → impact frame (hit-stop 40–80 ms on attacker anim speed) →
flash target (Highlight / colour) → particles → sound (layered) → damage number →
camera shake (small) → knockback.

## Reward feedback stack
Sound sting → number count-up → icon flies to HUD counter → counter bump scale →
particles → optional screen glow.

## Post-processing moments
Tween `ColorCorrection`/`Blur` for death, low health (red vignette, heartbeat),
underwater, power-ups, scares (quick desaturate + contrast spike).

## Performance budgets
- Total particle rate on screen modest on mobile; lower via a Graphics setting that
  scales emitter Rates and disables extras.
- Avoid hundreds of moving parts; tween CFrames of few objects; animate textures
  instead of geometry where possible.
