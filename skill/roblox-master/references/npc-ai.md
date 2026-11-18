# NPCs, Enemies & AI

## Rig & model
- Generate with `generate_avatar` (prompted R15 character) or build/insert a model with
  `Humanoid` + `HumanoidRootPart` + `Animator`. Non-humanoid creatures: `AnimationController`
  + `Animator`, move with `AlignPosition`/`LinearVelocity` or tween.
- Animations via `generate_animation` (idle, walk, run, attack, scream, death) loaded
  through `Animator:LoadAnimation`. Play on server for others to see NPC anims.
- `rootPart:SetNetworkOwner(nil)` for all server-controlled NPCs.

## Brain = state machine
States e.g. `Idle → Patrol → Suspicious → Chase → Attack → Search → Return`.
Each state: enter(), update(dt), exit(), transitions. Run all NPC brains from one
server loop at 5–10 Hz, not a loop per NPC.

## Perception
- **Sight**: within range and FOV cone (dot product), then raycast from head to target
  head ignoring the NPC; respect `Hidden` attribute, darkness modifiers.
- **Hearing**: noise events (sprint, door slam, item drop) with radius; NPC moves to
  last heard position.
- **Memory**: last known position + time; search pattern around it.

## Movement
- `PathfindingService:CreatePath({AgentRadius, AgentHeight, AgentCanJump, Costs})`,
  `ComputeAsync` (pcall), follow waypoints with `Humanoid:MoveTo`, handle
  `MoveToFinished` timeout and `path.Blocked`. Recompute every ~0.5–1 s while chasing,
  or direct `MoveTo` when there's line of sight (smoother).
- `PathfindingModifier` + material costs to steer NPCs (avoid water, prefer corridors).
- Stuck detection: if not moving > 2 s, jump / nudge / recompute / teleport to node.

## Horror director (tension pacing)
- Global "tension" value rises with time/objectives, drops after encounters.
- Director decides when the monster hunts, ambient scares (lights flicker, sounds,
  silhouettes), and gives relief windows. Never chase non-stop.
- Fairness: telegraph (sound cue, heartbeat, lights) before attacks; catch distance
  generous for players; escape routes and hiding spots everywhere.
- Jumpscares: client-side camera lock + animation + stinger, short (≤1.5 s), with a
  "reduce scares" setting. No gore.
- Meme-horror: absurd monster designs, funny death screens, silly sounds — mix tension
  and release (laughter is the relief).

## Combat AI
- Aggro list by damage/proximity; attack windups telegraphed; cooldowns; spacing so
  groups don't stack; bosses with phases (thresholds at 66%/33%), arena hazards.
- Difficulty scales with player count (health × (1 + 0.5 × (n−1))).

## Friendly NPCs
- Dialogue trees as data (`{ id, text, options = { {text, next, action} } }`),
  ProximityPrompt to talk, typewriter text, portraits via ViewportFrame.
- Shopkeepers, quest givers, guides. Ambient crowds: simple wander between waypoints,
  client-side only if purely cosmetic.

## Performance
- Cap active NPCs; despawn far ones; disable unused Humanoid states
  (`SetStateEnabled` for Climbing/Swimming etc. if irrelevant); pool NPC models.
