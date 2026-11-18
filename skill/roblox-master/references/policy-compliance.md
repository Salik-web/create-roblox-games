# Policy & Compliance (2026)

Rules change often. Before launch, verify current rules via `http_get` on the Roblox
creator docs (Community Standards, Content Maturity, Kids & Select publishing).

## Audience tiers
- Roblox Kids (≈5–8), Roblox Select (≈9–15), Roblox (16+ and trusted friends).
  Exact ages vary by region.
- Publishing for **16+** only: free; creator account must be age-checked.
- Publishing for **under-16 tiers** additionally requires: ID-verified creator,
  2-Step Verification, either a one-time refundable per-game fee or an active
  Roblox Plus/Premium subscription at least 2 months old, and passing an evaluation.
  If the subscription later lapses the game stays published for all ages.
- Kids/Select catalogs exclude games with social hangout or free-form drawing features
  and sensitive themes. Select allows up to Moderate maturity.
- Plan: launch 16+ (free), design content so it can later qualify for Select.

## Content maturity
- Every game needs the **Maturity & Compliance Questionnaire** completed in Creator Hub
  before it can be played publicly; unrated games are not playable.
- Labels: Minimal, Mild, Moderate, Restricted. Restricted requires an 18+ creator and
  ID-verified players; we don't target it.
- Horror: keep fear mild-to-moderate: no blood/gore, no realistic violence, no
  disturbing real-world themes. Fantasy creatures + jumpscares are fine at Mild/Moderate
  (answer the questionnaire honestly).
- Draft answers in `LAUNCH.md`; the creator submits them.

## Content rules
- No copyrighted/trademarked characters, logos, music, memes-characters, brand names.
- No real people (celebrities, YouTubers, politicians).
- No social media links or off-platform links in experiences.
- No gambling with real-world value. Paid random items are allowed only with odds
  disclosure and regional restrictions respected (`PolicyService`); off by default,
  built compliantly if the creator wants them.
- No misleading thumbnails/titles, no "free Robux" claims, no fake system messages.
- No dating/romance mechanics; no sexual content; no hate, bullying or harassment tools.
- Player-generated text must be filtered (`TextService`). Chat only via TextChatService.
- Team Create collaboration requires age checks for collaborators.
- Use `PolicyService:GetPolicyInfoForPlayerAsync` when showing anything
  region-restricted (e.g. some ad or link types, paid random items).

## Privacy
- Store only game data. Call `profile:AddUserId(userId)` so GDPR erasure works; follow
  any Right-to-Erasure messages Roblox sends (delete that user's keys).

## Before publish checklist
- [ ] Questionnaire answers drafted and honest
- [ ] All assets original/licensed; asset IDs logged
- [ ] No links, no copyrighted names in title/description/thumbnails
- [ ] Monetization: any paid randomness shows odds + respects PolicyService; prices clear
- [ ] Text filtering in place for any user text
