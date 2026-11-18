# External Tooling (optional, for bigger projects)

The default workflow is Studio + built-in MCP with script backups on disk. Add these
when a game grows or gets collaborators.

- **Git**: init the project folder; commit docs + `scripts/` backups after every phase
  (`git add -A && git commit -m "Phase 3: monster AI"`). Free history and rollback.
  Push to a private GitHub repo for off-site backup.
- **Rojo**: syncs `.luau` files on disk ↔ Studio, making disk the source of truth.
  If adopted, never edit synced scripts in Studio (they get overwritten); keep the MCP
  for building the world, testing and assets.
- **Wally**: package manager for Rojo projects (ProfileStore, etc.).
- **Selene** (linter) + **StyLua** (formatter) + **luau-lsp** (types in VS Code).
- **Place file backups**: File → Save to File (`.rbxl`) into
  `games/<slug>/backups/` before risky changes and each release.
- **Studio Packages**: share modules between places/games; update once, propagate.
- **Plugins**: only install well-known plugins; malicious plugins can inject backdoors.
