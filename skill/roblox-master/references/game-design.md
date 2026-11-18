# Game Design — Universal Method

Do not pick from a list of genres. Design from the experience outward. Any idea —
horror, meme, sport, cooking, social deduction, physics sandbox, rhythm, puzzle,
roleplay, idle, racing, fishing, survival, story, party minigames, or a hybrid —
goes through the same method.

## 1. Find the fantasy and the feeling
- **Fantasy**: who does the player get to be or do? ("a janitor surviving a cursed mall
  with friends", "running a chaotic sushi bar")
- **Feeling**: 1–3 target emotions (tension + laughter; mastery; cosy creativity;
  chaos with friends; collecting).
- **Hook in one line** — what a 12-second TikTok clip of the game shows.

## 2. Define the loops
- **Moment loop** (seconds): the verb the player repeats (run, hide, throw, build,
  catch, cook, jump). Must be satisfying alone with feedback/juice.
- **Session loop** (minutes): goal → challenge → reward → choice
  (round, level, chapter, run, shift, match).
- **Meta loop** (days): progression, collection, mastery, status, social standing.
- Write each as a cycle in `GDD.md`. If the moment loop isn't fun in a greybox, nothing
  else will save it.

## 3. Pick building blocks
Compose from `mechanics-catalog.md`: e.g. horror-meme co-op = Round/Lobby system +
Chase AI + Objectives (collect/escape) + Hiding + Jumpscare director + Spectate +
Cosmetics + Troll items + Daily rewards. A brand-new mechanic is fine — design it as a
new block with inputs, rules, feedback and edge cases.

## 4. Roblox-specific design truths
- Players arrive from a thumbnail on a phone, often with friends, often young (16+ for
  our free launch tier). They leave within 1 minute if confused.
- **Social is the engine**: co-op, competition, showing off, trolling, inviting.
  Every game needs a reason to play *with* someone and a way to show off.
- Short sessions and instant restart. Drop-in/drop-out.
- Visible progress: numbers going up, unlocking areas, levels, titles.
- Spectacle and humour travel well on social media.
- Copy what works structurally from popular games, never their content.
- Ship small, update often; the algorithm rewards engagement and retention.

## 5. Scope for a 3–4 day v1
- 1 core loop polished, 1–3 maps/areas or a well-made procedural/round map, 5–15
  pieces of content per collection (skins, enemies, levels), full monetization,
  daily rewards, 1 retention system (quests or collection), leaderboard, tutorial.
- Everything else goes to the update roadmap (it's also your update plan).

## 6. Difficulty & flow
- Teach by doing: one new idea at a time, safe practice, then a test.
- Difficulty sawtooth: ramp, relief, bigger ramp.
- Fail fast, retry instantly, keep partial progress.
- Rubber-banding in multiplayer so groups stay together.

## 7. Idea validation (before building)
Score 1–5 each; build if ≥ 22/30, rework if lower:
1. Clip-worthy hook (would it make a good 15 s video?)
2. Fun in the first minute
3. Social/friend factor
4. Monetization fit (cosmetics visible? convenience meaningful?)
5. Replayability (rounds, randomness, progression)
6. Buildable in 3–4 days at high quality
Record the scores in `GDD.md`.

## 8. Experiment mindset
- Each game is an experiment with a hypothesis ("co-op horror with meme humour gets
  >25% D1 retention"). Write it in `GDD.md`, check it in `data-review`.
- Keep a shared library: systems built in one game get copied into `scaffold`-style
  modules in the project's `library/` so the next game starts faster.
