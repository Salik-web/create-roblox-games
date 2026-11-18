# Workflow: Debug / Change Request

1. **Reproduce**: read the report; find related scripts (`script_search`,
   `script_grep`), inspect instances; playtest the exact scenario; collect
   `get_console_output` and a `screen_capture`.
2. **Locate root cause**: read the code path end to end (client input → remote →
   server handler → data → replication → client display). Add temporary `print`/`warn`
   with a `[DEBUG]` tag if needed.
3. **Fix at the root**, matching architecture rules. Don't patch symptoms
   (no `task.wait(1)` to "fix" races — wait for the actual condition).
4. **Verify**: replay the scenario + quick regression of nearby features. Remove
   `[DEBUG]` prints.
5. **Record**: update script backups, `PROGRESS.md` (bug, cause, fix), `save_place`.
6. **Reply** in 2–4 lines: cause, change, how to check.

Common culprits: race on character/data load, client-only change not replicated,
remote name mismatch, StreamingEnabled nil parts, wrong datamodel (edited in play
mode), CollisionGroup/CanTouch settings, missing pcall around web calls, attribute
type mismatch, UI ZIndex/visibility, mobile input not bound.
