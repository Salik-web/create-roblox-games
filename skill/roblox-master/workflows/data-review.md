# Workflow: Data Review (scale, fix or kill)

Run 7 days after launch and then weekly. The creator pastes or screenshots Creator Hub
analytics (or you read exported CSVs they put in `games/<slug>/media/analytics/`).

1. Record metrics in `PROGRESS.md` (date, CCU peak, visits, CTR, D1, D7, session
   length, payer %, revenue R$, top products).
2. Diagnose with `references/analytics.md` decision table.
3. Decide:
   - **Scale** (D1 ≥ ~20% or clearly rising): weekly updates, events, consider small
     ad spend from earnings, more cosmetics.
   - **Fix** (one weak metric): one targeted change per week (icon/thumbnail, first
     5 minutes, retention system, catalog), re-measure.
   - **Kill/park** (weak everywhere after 2 fix cycles): stop, note learnings, move
     reusable systems into the project `library/`, mark Parked in INDEX.md.
4. Write the decision and the experiment for next week in `DECISIONS.md`.
5. Update `games/INDEX.md` with the latest numbers.
