# Analytics & KPIs

## Built-in
Creator Hub → Analytics: retention (D1/D7/D30), session length, playtime, concurrent
users, conversion (payer %), ARPDAU/ARPPU, revenue by product, acquisition sources,
thumbnail/icon performance, discovery impressions → plays (click-through rate),
performance (crashes, FPS by device).

## Custom events (AnalyticsService) via scaffold `Telemetry`
- **Onboarding funnel**: `LogOnboardingFunnelStepEvent(player, step, name)` — joined,
  moved, first objective, first reward, tutorial done, first shop open.
- **Funnels**: `LogFunnelStepEvent` for multi-step flows (shop open → item view →
  prompt → purchase).
- **Economy**: `LogEconomyEvent(player, flowType, currency, amount, balanceAfter,
  transactionType, itemSku)` on every earn/spend.
- **Progression**: `LogProgressionEvent` (level/chapter start/complete/fail).
- **Custom**: `LogCustomEvent(player, name, value)` for anything else (deaths by
  monster, scare skipped, mode chosen).
Verify exact signatures with `http_get` on the AnalyticsService docs before coding;
wrap in pcall; don't spam (aggregate per round).

## KPI targets (rough guide for small games)
| Metric | Weak | OK | Strong |
|---|---|---|---|
| D1 retention | < 10% | 15–25% | > 30% |
| D7 retention | < 3% | 5–8% | > 10% |
| Avg session | < 5 min | 8–15 min | > 20 min |
| Payer conversion | < 0.5% | 1–3% | > 4% |
| Thumbnail CTR | < 2% | 3–6% | > 7% |

## Reading the data (see `workflows/data-review.md`)
- Low CTR → icon/thumbnail/title problem.
- Good CTR, bad D1 → first-5-minute problem (onboarding, fun, clarity, bugs, lag).
- Good D1, bad D7 → no long-term goals/retention systems.
- Good retention, low conversion → catalog/placement/prices problem.
- Funnel drop at a step → that step is broken or confusing.
Record each review and the resulting decisions in `PROGRESS.md`/`DECISIONS.md`.
