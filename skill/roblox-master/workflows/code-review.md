# Workflow: Code Review

For each script (or the changed ones):
- Correct place & class (server code not in ReplicatedStorage; client code not in SSS).
- `--!strict`/types where practical; no deprecated APIs; `task` library.
- Single responsibility; no god scripts; no circular requires; no top-level yields.
- All web calls pcall'd with retries; errors logged with context.
- Connections cleaned up (Trove); player tables cleared on leave.
- Remote handlers follow the security checklist.
- Magic numbers moved to Config/Catalog.
- Clear names; short comments only where intent isn't obvious.
- Backups on disk match Studio source.
Fix issues directly, then summarize in PROGRESS.md.
