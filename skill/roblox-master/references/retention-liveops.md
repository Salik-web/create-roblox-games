# Retention & Live Ops

Roblox discovery rewards engagement and retention. Money follows players who come back.

## Day-1 retention tools
- **Daily login rewards**: 7-day streak calendar, day 7 big reward (exclusive cosmetic
  piece), streak resets gently (or grace day). Day index = `math.floor(os.time()/86400)`.
- **Daily/weekly quests**: 3 daily (easy/medium/hard), 3 weekly; reroll once free.
- **Unfinished business**: end sessions with a near-complete goal visible.
- **Timers**: crops/idle/crafting that complete later (not paywalled).
- **Notifications**: Roblox Experience Notifications (opt-in) for meaningful events
  (crops ready, event started). Check current API/eligibility in docs.
- **Group join bonus**: reward + chat tag for joining the creator's group (when one
  exists) — check with `player:IsInGroup(id)`.
- **Favorite/like reminder**: gentle, after a good moment, at most once per session.
  (Use `AvatarEditorService:PromptSetFavorite` where appropriate.)

## Long-term
- Collections, prestige/rebirth, seasonal ranks, titles, leaderboards (weekly reset
  gives everyone a fresh chance), rare free drops, secret endings/easter eggs.
- Social: friend bonuses, invite prompts (`SocialService:PromptGameInvite`), party
  teleports, co-op achievements.

## Live-ops calendar (after launch)
| When | What |
|---|---|
| Week 1 | Daily bug fixes, balance from data, thumbnail/icon tests |
| Week 2 | Update 1: new content row (map/skins/enemies), codes for socials |
| Every 1–2 weeks | Content update + small event |
| Monthly | Larger update or limited-time event with event currency and exclusive cosmetics |
| Holidays | Themed event (Halloween, winter, Eid, summer) — reskin existing systems |

- Update = new content + title tag "[UPDATE]" in the experience name/description +
  new thumbnail + social clip. Players and the algorithm react to updates.
- Keep `UPDATE_LOG.md` and an in-game "What's new" board.
- Server-wide events: scheduled by UTC time from Config, or triggered by
  MessagingService for "live" moments.
- Feature flags let you toggle event content without republishing code.

## Re-engagement after drops
If CCU falls: run a 2x weekend, release codes, publish a new thumbnail, ship a small
update, post a new clip. If retention is bad, fix onboarding first (it's usually the
first 2 minutes).
