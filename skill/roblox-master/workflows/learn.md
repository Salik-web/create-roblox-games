# Workflow: Learn (grow the skill)

Run at the end of every build phase, fix, polish, audit, review and update — and
whenever the creator says "remember this", "add this to the skill", or something
completely new comes up.

## 1. Capture
Collect candidates from this session:
- New mechanic, hybrid structure or system design (even if it's never been done before).
- Studio/MCP tool, API, property or Roblox feature that's new, renamed or behaves
  differently from the references.
- Bug pattern + root cause + fix.
- Visual, audio, feel or UI trick that clearly improved quality (screenshots before/after).
- Design, monetization or retention results from data reviews.
- Policy or rules change.
- Workflow step that was missing or wasteful.
- Creator preference ("I like X", "never do Y").
Skip anything one-off or obvious.

## 2. Log
Append each to `LEARNINGS.md` → Inbox: date, type, learning (1–2 lines), source
(game slug, docs URL, test), evidence, target file. Creator preferences go straight to
"Creator preferences". Data results go to "Results across games".

## 3. Verify
A learning is verified when at least one is true:
- It worked in a playtest (console clean, behaviour confirmed).
- Official Roblox docs confirm it (`http_get` or WebFetch on create.roblox.com).
- Game data supports it (data review).
- The creator explicitly asked for it to be a rule.
Unverified items stay in the Inbox; test them next time they're relevant.

## 4. Promote (merge into the skill)
1. Back up the target file (git commit, or copy to `.history/<date>-<file>`).
2. Edit the right place: reference section, sharp-edges table, mechanics catalog
   ("Discovered blocks" or a full entry), workflow step, template field, or scaffold
   code (scaffold changes must be tested in a playtest first).
3. If it contradicts existing advice, **replace** the old advice — don't leave both.
4. Remove it from the Inbox. Bump version in `CHANGELOG.md` (patch = fix/tweak,
   minor = new block/section/workflow) with date, files and source.
5. If it's urgent and not merged yet, put it in "Active rules".

## 5. Report
One line to the creator: "Skill learned: <short list>" (only if something was promoted).

## Never
- Store secrets, account details, or anything copyrighted in the skill.
- Promote unverified guesses as rules.
- Delete the creator's preferences without being asked.
