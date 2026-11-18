# Workflow: Refresh Knowledge

Run monthly, before a new game, or when the creator asks "anything new on Roblox?".

1. Check the Studio MCP tool list now available (compare with `references/mcp-studio.md`).
   New/renamed/removed tools → update the reference and SKILL.md tool map.
2. Read official sources (WebFetch / `http_get`):
   - create.roblox.com/docs — Studio MCP, monetization, publishing (Kids & Select),
     content maturity, DevEx, analytics, release notes.
   - Roblox DevForum announcements and Roblox newsroom (latest posts).
   - The ProfileStore repo for API changes.
   Focus on: new engine features, new APIs/services, new monetization programs,
   policy/age-tier changes, DevEx rate changes, deprecations.
3. If web search is available, scan what's trending on Roblox (themes, structures,
   viral mechanics) and add notable ones to `LEARNINGS.md` (type Design result /
   Mechanic, marked "trend").
4. Log every change in `LEARNINGS.md` → Inbox with the source URL, then run
   `workflows/learn.md` steps 3–5 (docs-confirmed items count as verified).
5. Reply with a short "What's new" list and what it means for current games
   (e.g. "new rewarded ads format — could add to <game>").
