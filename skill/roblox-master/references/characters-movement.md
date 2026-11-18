# Characters, Movement & Physics

## Avatar settings (Game Settings → Avatar / StarterPlayer)
- R15 for modern animation and the US 18+ DevEx rate eligibility (R6 disqualifies).
- Decide: player avatars (default, social) vs. forced character (horror roles,
  themed games) via `StarterCharacter` or `HumanoidDescription` application on spawn.
- Collisions between players: use CollisionGroups to disable player-player collisions
  in obbies/lobbies to prevent blocking and trolling.

## Movement tuning
- WalkSpeed 16 default; sprint 22–26; crouch 8. JumpPower/JumpHeight per game feel.
- Server owns speed changes (sprint/stamina/boosts) so exploiters can't just claim
  them; client requests, server applies with validation.
- Camera: `CameraMaxZoomDistance`, first-person lock for horror
  (`CameraMode = LockFirstPerson`), shift-lock toggle, custom camera via
  `BindToRenderStep` for top-down/side-scroll.
- Mobile: thumbstick + jump button default; extra actions via
  `ContextActionService:BindAction(..., true)` creates touch buttons; position them.
- Gamepad: map actions with `Enum.KeyCode.ButtonX` etc.

## Character features
- Footsteps by material (client, `Humanoid.FloorMaterial`).
- Flashlight: SpotLight in head/tool, battery meter, flicker; server replicates on/off.
- Ragdoll on death (BallSocketConstraints replacing Motor6Ds) for comedy games.
- Double jump, dash, wall-run, glide, grapple: client feel + server sanity checks.
- Health regen, damage numbers, shields, status effects table (`Burning`, `Slowed`) with
  durations on server and icons on client.

## Physics
- Anchor everything static. Use constraints, not welds-with-velocity hacks.
- Mover constraints: `LinearVelocity`, `AngularVelocity`, `AlignPosition`,
  `AlignOrientation`, `VectorForce`. `ApplyImpulse` for one-off pushes.
- Network ownership: server for shared/important objects, player for their own vehicle.
- `CollisionGroup` via `PhysicsService:RegisterCollisionGroup` and
  `CollisionGroupSetCollidable`; set `part.CollisionGroup = "Name"`.
- Fast projectiles: raycast steps (FastCast-style) instead of physical parts.
- Moving platforms: `PrismaticConstraint`/`TweenService` on anchored parts with
  `AssemblyLinearVelocity` set so players ride smoothly.

## Spawning
- `SpawnLocation`s per team/area; or custom spawn by setting the character CFrame on
  `CharacterAdded` (wait for HumanoidRootPart). Spawn protection (ForceField) briefly.
- Respawn time via `Players.RespawnTime`; custom respawn flows with
  `Players.CharacterAutoLoads = false` + `player:LoadCharacter()`.
