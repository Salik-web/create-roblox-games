# Workflow: Security Audit

1. Use a `subagent` (explore) or `script_grep` to list every `OnServerEvent`,
   `OnServerInvoke`, `ProcessReceipt`, `PromptGamePassPurchaseFinished`, `Touched`
   reward, ProximityPrompt `Triggered`, DataStore write, `TeleportService` call.
2. For each handler apply the checklist in `networking-security.md` (rate limit,
   types, ownership, state, distance, cooldown, server-side values). Fix gaps.
3. Check ReplicatedStorage/client code for secrets (admin IDs, drop tables, debug
   remotes). Move or remove.
4. Receipts: idempotency by PurchaseId, NotProcessedYet on failure, profile active.
5. Data: ProfileStore usage, kick on load failure, no client-written data.
6. Assets: scan all scripts in inserted models for backdoor patterns
   (`require(%d`, getfenv, loadstring, HttpService, obfuscation).
7. Text: filtering for any player-written text.
8. Exploit simulation in a playtest: via `execute_luau` (Client datamodel) fire remotes
   with bad args (negative, NaN, huge, wrong types, other players' IDs, rapid spam);
   confirm the server rejects them and nothing breaks.
9. Write findings and fixes in `PROGRESS.md` (Security section).
