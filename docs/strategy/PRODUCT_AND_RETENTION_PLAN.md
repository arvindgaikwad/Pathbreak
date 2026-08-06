# Pathbreak — Product, Retention, and Live Operations Plan

Last updated: 2026-08-06

## Product objective

Pathbreak must become more than a ten-level arrow-clearing prototype. The commercial product needs a repeatable content system, a visible progression journey, meaningful mode choice, and enough variation to create long-term player interest.

## Core game modes

### Relax Mode

- No life loss.
- No forced timer.
- Unlimited restart.
- Optional hints.
- Calm progression and completion feedback.
- Default recommendation for the broad audience.

### Challenge Mode

- Limited mistakes.
- Stars and efficiency goals.
- Move count and best time.
- Daily challenge and streaks later.
- Designed for mastery without changing the fundamental puzzle rule.

## Chapter roadmap

Introduce one mechanic every 10–15 levels instead of adding many systems at once.

### Chapter 1 — First Paths

- Standard directional paths.
- Straight and bent pieces.
- Clear tutorial language.
- Purpose: establish trust and readability.

### Chapter 2 — Colour Gates

- Some paths must exit through matching edge gates.
- Adds planning without requiring complex controls.

### Chapter 3 — Switch Paths

- Removing a marked path changes another path's direction.
- Introduce with highly controlled tutorial levels.

### Chapter 4 — Bridges

- Paths can cross at explicit bridge nodes without blocking.
- Visual clarity is critical.

### Chapter 5 — Linked Paths

- Two paths share a state or clear together.
- Use sparingly to avoid unpredictability.

### Chapter 6 — Fragile Nodes

- Certain board cells create an efficiency constraint or optional challenge.
- Keep the base solution fair in Relax Mode.

## Launch content plan

| Content group | Levels |
|---|---:|
| Tutorial/showcase | 5 |
| Easy | 20 |
| Normal | 25 |
| Hard | 20 |
| Mechanic showcase | 5 |
| Total | 75 |

Every level must be:

- Schema-valid.
- Solver-verified.
- Rated for difficulty.
- Tested on a small phone.
- Manually reviewed for readability.
- Assigned an intended learning or challenge purpose.

## Content pipeline

```text
Level editor
  → schema validator
  → solvability solver
  → difficulty metrics
  → automated simulation
  → human playtest
  → release pack
```

Required difficulty signals:

- Number of pieces.
- Number of initially valid moves.
- Solution depth.
- Branching factor.
- Forced-move ratio.
- Path density.
- Average path length.
- Number of bends.
- Minimum spacing.
- Expected ambiguity score.

Published research suggests difficulty modelling is strongest when simulated data is combined with player analytics rather than relying on either alone.

Reference:
https://arxiv.org/abs/2401.17436

## Retention loop

### Session loop

```text
Open game
  → Continue recommended level
  → Solve 1–5 levels
  → Earn stars / chapter progress
  → See next goal
  → Leave with progress safely saved
```

### Daily loop

- Daily puzzle after core progression is stable.
- One reward for completion, not for repeated login pressure.
- Missed days should not permanently punish the player.

### Weekly loop

- New curated level pack.
- Optional weekly challenge board.
- Visible “new levels” entry in level select.

### Monthly loop

- New visual theme or mechanic variation.
- Chapter progress event.
- Store listing and creative refresh.

## Retention systems to include

- Clear chapter map.
- Stars and personal bests.
- Recommended next level.
- Daily puzzle.
- New-level badge.
- Gentle streak with recovery, introduced later.
- Achievements based on mastery, not ad watching.

## Retention systems to avoid initially

- Energy timers.
- Multiple currencies.
- Loot boxes.
- Mandatory login rewards.
- Aggressive push notifications.
- Social pressure.
- Fake scarcity.
- Complex collection meta before core retention is proven.

## Analytics event plan

### Acquisition and onboarding

- `first_open`
- `main_menu_viewed`
- `tutorial_started`
- `tutorial_completed`
- `how_to_play_opened`

### Gameplay

- `level_started`
- `path_tapped`
- `path_escaped`
- `blocked_tap`
- `ambiguous_tap_ignored`
- `hint_requested`
- `hint_used`
- `restart_used`
- `level_failed`
- `level_completed`
- `level_abandoned`

### Settings and accessibility

- `relax_mode_selected`
- `challenge_mode_selected`
- `high_contrast_changed`
- `reduce_motion_changed`
- `haptics_changed`

### Monetization

- `rewarded_offer_viewed`
- `rewarded_started`
- `rewarded_completed`
- `reward_granted`
- `interstitial_shown`
- `remove_ads_offer_viewed`
- `purchase_started`
- `purchase_completed`
- `purchase_restored`

Do not collect more data than needed. Document every event in the privacy and analytics specification.

## KPI dashboard

### Product health

- Tutorial completion.
- Level 1–5 completion funnel.
- D1, D7, and D30 retention.
- Sessions per active user.
- Median session length.
- Levels completed per session.
- Hint rate by level.
- Restart and failure rate by level.
- Ambiguous-tap rate.

### Technical health

- Crash-free users.
- ANR rate.
- Average load time.
- Save failure rate.
- Reward-grant failure rate.
- Device-resolution breakdown.

### Business health

- Store conversion.
- Organic versus paid installs.
- Ad revenue per daily active user.
- Purchase conversion.
- Revenue by country.
- User-acquisition cost.
- Day-30 value by cohort.

## Soft-launch interpretation

- High installs + low tutorial completion: store promise and first experience do not match.
- Good tutorial + poor Level 3–5 completion: difficulty or clarity problem.
- Good completion + weak D1: insufficient reason to return.
- Good retention + low revenue: monetization placement or geography problem.
- Good revenue + falling ratings: monetization is damaging trust.

## Player support loop

Each week:

1. Categorize reviews and support messages.
2. Count repeated complaints.
3. Link complaints to analytics evidence.
4. Fix critical trust issues first: lost progress, wrong taps, ads, purchases, crashes.
5. Publish concise release notes.

## Product roadmap after launch

### Phase A — Prove core retention

- 75 levels.
- Two modes.
- Strong touch controls.
- Basic daily puzzle.
- Minimal monetization.

### Phase B — Build content durability

- 150+ levels.
- Two additional chapter mechanics.
- Weekly packs.
- Better difficulty model.

### Phase C — Expand identity

- Final visual overhaul.
- Theme collection.
- Events and achievements.
- Localization.

### Phase D — Scale only after evidence

- Paid acquisition.
- More countries.
- iOS evaluation.
- Additional puzzle products using the same level/content technology.
