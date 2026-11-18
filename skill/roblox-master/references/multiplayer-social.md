# Multiplayer & Social

## Server size
Set Max Players per design (co-op horror 4–8, party games 8–16, obby/sim 15–30).
Smaller servers = fuller, livelier rooms at low player counts. Enable "Fill servers"
style behaviour by keeping servers small early.

## Teams & parties
- `Teams` service for team games; auto-balance on join and between rounds.
- Party system: invite UI → party table on server → teleport together
  (`TeleportService:TeleportAsync(placeId, players, TeleportOptions)` with
  `ReservedServerAccessCode` from `ReserveServer`). pcall + retry; handle
  `TeleportInitFailed`. Pass small data via `TeleportOptions:SetTeleportData` (client-
  visible, don't trust) — authoritative data travels through DataStore/profile.
- Multi-place experiences: Lobby place + Match place(s) in the same universe.

## Matchmaking
- Simple: in-lobby queue pads → when N players are on the pad or timer ends → reserve
  server and teleport.
- Cross-server: `MemoryStoreService` queue/sorted map + a lobby server loop that groups
  players by mode/skill and teleports them.

## Invites & friends
- `SocialService:PromptGameInvite(player)` from an "Invite friends" button; reward
  friends-in-server bonus. `player:IsFriendsWith(id)` checks (pcall).
- Show friends on leaderboards; party up with friends automatically on join when
  possible (`Player.FollowUserId` for "followed a friend in").

## Trading (only if core to design)
High exploit/scam risk. Both sides confirm with a countdown, server swaps atomically
in both profiles, logs every trade, blocks recently acquired items briefly, no trading
of Robux-bought items unless intended. Ages: be careful; consider 16+ only.

## Communication
- `TextChatService` only; custom channels (team chat) via `TextChannel`s.
- Quick-chat/emote wheels let everyone communicate (players without chat access too).
- Proximity voice works automatically for eligible users; design co-op so it's fun
  with or without voice.

## Server-wide moments
Global announcements (MessagingService), "first to beat the boss in this server",
server goals (community progress bar), spectating good players, emotes at win.

## Private servers
Enable for social/co-op games; can add owner commands (map select, admin-lite toys).
