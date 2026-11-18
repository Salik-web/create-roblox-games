# Monetization

Goal: players *want* to pay because it makes the game more fun, more expressive or more
social, not because they're blocked. Every game ships a full catalog from v1.

## Revenue streams on Roblox
| Stream | What | Notes |
|---|---|---|
| Game passes | One-time permanent perks | Creator receives ~70% of price |
| Developer products | Repeatable purchases | Currency packs, revives, boosts, skips |
| Experience subscriptions | Monthly recurring perks | Strong for VIP-style ongoing value; check current eligibility rules in docs |
| Premium Payouts | Paid by engagement time of Premium members | Free: retention = money. Can add Premium-only cosmetic perks |
| Rewarded / immersive ads | Ad formats in experience | Check current program eligibility & API in docs before building |
| Avatar items in-game | Sell UGC/avatar items via `PromptPurchase` | Commission on sales; good for fashion/roleplay |
| Creator Store / UGC | Sell models, plugins, accessories | Separate income stream from the same skills |

Look up current rules with `http_get` before building subscriptions, ads or commerce —
these programs change often.

## Catalog design (per game)
Build a balanced catalog across these buckets:
1. **Identity/cosmetic** (biggest seller): skins, outfits, trails, auras, death effects,
   emotes, nametags/titles, custom sounds, weapon/flashlight/tool skins, pets that
   follow you. Must be **visible to others**.
2. **Convenience**: 2x currency, faster movement, auto-collect, extra slots, teleport
   to unlocked areas, skip stage (product), revive (product).
3. **Social/power fantasy (fair)**: troll items (whoopee cushion, fake jumpscare on a
   friend, banana peel), admin-lite toys in private servers, VIP lounge, radio/boombox.
4. **Content**: extra chapters/maps/modes (careful: core game stays free & complete).
5. **Currency packs** (products): 4–6 tiers with increasing bonus %.
6. **Starter pack** (one-time, discounted feel): shown after first session milestone.
7. **Private servers**: enable in settings for co-op/social games; price 50–150 R$.

## Price anchors (Robux)
- Small cosmetic 25–99 • Signature skin 149–399 • 2x currency 199–499 • VIP 249–999
- Products: revive 15–49 • skip 25–79 • currency packs 25 / 99 / 249 / 499 / 999 / 2499
- Always include something cheap (impulse) and something expensive (whales).
- Use Creator Hub's price optimization / regional pricing features where available.
- Check what top games in the same niche charge; record decisions in `MONETIZATION.md`.

## Placement (where players see offers)
- Shop button always visible on HUD (with "NEW"/"SALE" badge animation).
- Contextual prompts: after death ("Revive?"), at a locked area ("VIP door"), after a
  run ("2x coins?"), when a friend uses a cosmetic ("Get this skin" on inspect).
- In-world: preview pads/mannequins showing premium skins, VIP area visible through
  glass, leaderboard showing titles.
- Never more than one unrequested prompt per few minutes. Never prompt in the first
  60 seconds. Never block the core loop.

## Implementation rules
- IDs live in `Config.GamePasses` / `Config.Products`; `0` = not created yet (UI shows
  "Coming soon", grant logic skipped) so the game runs before setup.
- Game pass ownership: `UserOwnsGamePassAsync` on join (pcall, cached) +
  `PromptGamePassPurchaseFinished` to grant instantly after purchase in-session.
- Developer products: one `MarketplaceService.ProcessReceipt` callback for the whole
  server (scaffold `MonetizationService`). Flow: find player profile → if
  `PurchaseId` already in receipts log → `PurchaseGranted`; else grant → record
  PurchaseId → return `PurchaseGranted`. Player gone / profile missing / error →
  `NotProcessedYet` (Roblox retries).
- Subscriptions: check status on join and on `UserSubscriptionStatusChanged` (verify
  API names in docs).
- Premium: `player.MembershipType == Enum.MembershipType.Premium`; listen to
  `Players.PlayerMembershipChanged`; offer Premium upsell via
  `MarketplaceService:PromptPremiumPurchase` only from a Premium-perk context.
- Gift purchases for friends: products that grant to a target player (validate target
  is in server).
- Track every prompt shown, purchase and failure with `Telemetry` (economy + custom).

## Defaults (creator can override — see SKILL.md §4)
- **Paid random items** (paid crates/spins/eggs): avoided by default. If the creator
  wants them, build them compliantly: show odds before purchase, use
  `PolicyService:GetPolicyInfoForPlayerAsync(player).ArePaidRandomItemsRestricted` to
  hide/disable them where restricted (verify field name in docs), and offer a
  direct-buy alternative where possible.
- Competitive advantage for payers in PvP: avoided by default (hurts retention and
  reviews). If the creator wants it, implement it and note the risk once.

## Always (Roblox rules)
- No fake discounts, no fake timers, no misleading "free" claims.
- Refund-safe: never take away a granted item because of a later state glitch.

## Store page assets
For each pass/product: name (short, exciting), description (what you get, 1–2 lines),
icon concept (512×512, bold, readable small, consistent style). Generate icon art with
`generate_mesh` renders/`screen_capture` + creator's Canva, or design in-Studio scenes
and capture them.

## Creating passes/products
Preferred: `open_cloud_invoke` with `game-pass:*` / `developer-product:*` scopes (see
`mcp-studio.md`), after the creator approves the final list. Fallback: give the creator
a numbered list of Creator Hub steps with exact names/prices/descriptions, then paste
IDs into `Config`.
