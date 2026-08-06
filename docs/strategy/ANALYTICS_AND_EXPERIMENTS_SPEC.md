# Pathbreak — Analytics and Experiments Specification

Last updated: 2026-08-06

## Purpose

Analytics exists to answer product questions, not to collect everything possible. Pathbreak should collect the minimum data required to understand onboarding, difficulty, touch fairness, retention, technical health, and monetization.

No personally identifying information should be included in event parameters. The final implementation must match the privacy policy and Google Play Data Safety declaration.

## Core questions

1. Do players understand the rule through Level 1?
2. At which level do players fail, restart, use hints, or leave?
3. Do touches select the intended path reliably?
4. Do players return the next day and next week?
5. Does Relax Mode or Challenge Mode retain better?
6. Do ads or purchases reduce satisfaction or retention?
7. Which devices produce crashes, slow loads, or layout problems?

## Event naming rules

- Use lowercase snake_case.
- One event represents one completed occurrence.
- Store state as parameters rather than creating many near-duplicate events.
- Use stable parameter names.
- Do not rename production events casually; version them when meaning changes.

## Global parameters

Attach where supported:

| Parameter | Type | Example | Purpose |
|---|---|---|---|
| `app_version` | string | `0.5.0` | Release comparison |
| `platform` | string | `android` | Future platform comparison |
| `device_class` | string | `phone_small` | Layout/performance analysis |
| `screen_width` | integer | `393` | Touch and layout debugging |
| `screen_height` | integer | `873` | Touch and layout debugging |
| `mode` | string | `relax` | Mode comparison |
| `session_id` | string | random local ID | Session grouping |
| `install_cohort` | string | `2026_08_10` | Retention cohorting |

Avoid sending advertising IDs or account identifiers unless a future business requirement, consent flow, and policy review justify them.

## Event catalogue

### Session and navigation

#### `first_open`

Sent once after a successful first launch.

Parameters:

- `is_fresh_install`
- `initial_language`
- `device_class`

#### `session_started`

Parameters:

- `days_since_install`
- `highest_level_unlocked`
- `completed_level_count`

#### `session_ended`

Parameters:

- `session_seconds`
- `levels_started`
- `levels_completed`
- `exit_screen`

#### `screen_viewed`

Parameters:

- `screen_name`
- `source_screen`

Allowed initial screen names:

- `main_menu`
- `level_select`
- `gameplay`
- `pause`
- `result`
- `failure`
- `how_to_play`

### Tutorial and progression

#### `tutorial_started`

Parameters:

- `level_id`

#### `tutorial_step_completed`

Parameters:

- `step_id`
- `seconds_from_start`
- `used_hint`

#### `tutorial_completed`

Parameters:

- `completion_seconds`
- `moves`
- `mistakes`
- `hints_used`

#### `level_started`

Parameters:

- `level_id`
- `chapter_id`
- `difficulty_label`
- `piece_count`
- `attempt_number`
- `mode`

#### `level_completed`

Parameters:

- `level_id`
- `completion_seconds`
- `moves`
- `mistakes`
- `hints_used`
- `stars`
- `attempt_number`

#### `level_failed`

Parameters:

- `level_id`
- `reason`
- `moves`
- `mistakes`
- `remaining_pieces`

#### `level_abandoned`

Send when gameplay is exited before completion and the level has been active for at least five seconds.

Parameters:

- `level_id`
- `elapsed_seconds`
- `remaining_pieces`
- `last_action`

### Touch fairness

#### `path_tapped`

Sampling may be required at scale.

Parameters:

- `level_id`
- `piece_id`
- `tap_result`: `escaped`, `blocked`, `ignored_animation`
- `distance_to_path_px`
- `candidate_count`

#### `ambiguous_tap_ignored`

This is a core product-quality event.

Parameters:

- `level_id`
- `candidate_count`
- `best_distance_px`
- `second_best_distance_px`
- `screen_width`

#### `empty_board_tap`

Sample rather than log every occurrence if volume is high.

Parameters:

- `level_id`
- `distance_to_nearest_path_px`

#### `hint_used`

Parameters:

- `level_id`
- `hints_remaining`
- `source`: `free_tutorial`, `inventory`, `rewarded_ad`

#### `restart_used`

Parameters:

- `level_id`
- `elapsed_seconds`
- `remaining_pieces`
- `mistakes`

### Accessibility and settings

#### `setting_changed`

Parameters:

- `setting_name`
- `old_value`
- `new_value`
- `source_screen`

Initial setting names:

- `sound`
- `haptics`
- `reduce_motion`
- `high_contrast`

### Monetization

#### `rewarded_offer_viewed`

Parameters:

- `placement`
- `level_id`
- `reward_type`

#### `rewarded_started`

Parameters:

- `placement`
- `network`

#### `rewarded_completed`

Parameters:

- `placement`
- `network`

#### `reward_granted`

Parameters:

- `placement`
- `reward_type`
- `grant_success`

#### `interstitial_shown`

Parameters:

- `placement`
- `levels_since_last_interstitial`
- `minutes_since_last_interstitial`

#### `purchase_started`

Parameters:

- `product_id`
- `localized_price`
- `currency`

#### `purchase_completed`

Parameters:

- `product_id`
- `transaction_result`

Do not send raw purchase tokens into general analytics.

## Funnel definitions

### Onboarding funnel

```text
first_open
→ main_menu viewed
→ tutorial_started
→ tutorial_completed
→ level_2_started
→ level_5_completed
→ level_10_completed
```

### Monetization funnel

```text
rewarded_offer_viewed
→ rewarded_started
→ rewarded_completed
→ reward_granted
```

### Purchase funnel

```text
remove_ads_offer_viewed
→ purchase_started
→ purchase_completed
```

## KPI definitions

### Tutorial completion rate

`tutorial_completed users / tutorial_started users`

### Level completion rate

`unique users completing level / unique users starting level`

### Ambiguous-tap rate

`ambiguous_tap_ignored / gameplay path-intent interactions`

This metric is not automatically bad. A moderate number may show that protection is preventing false penalties. Investigate when it rises sharply on specific levels or screen sizes.

### D1 retention

Percentage of new users returning on the calendar day after first open.

### D7 retention

Percentage of new users returning seven calendar days after first open.

### Crash-free users

`users without crash / active users`

### Ad impressions per DAU

`interstitial + rewarded impressions / daily active users`

## Initial quality gates

These are internal planning gates, not universal industry truths:

| Metric | Investigate below | Soft-launch target |
|---|---:|---:|
| Tutorial completion | 65% | 75%+ |
| Level 5 completion among installers | 35% | 50%+ |
| D1 retention | 25% | 30%+ |
| D7 retention | 5% | 7%+ |
| Crash-free users | 99.0% | 99.5%+ |
| Average rating | 4.0 | 4.3+ |
| Reward-grant success | 99.0% | 99.9%+ |

## Experiment rules

- Run one major product experiment at a time per audience segment.
- Define hypothesis, primary metric, guardrail metrics, duration, and decision threshold before launch.
- Do not declare success from tiny samples.
- Do not optimize ad revenue while ignoring retention, rating, or session completion.
- Keep a permanent control group when testing monetization intensity at meaningful scale.

## Initial experiment backlog

### Experiment A — Store positioning

Hypothesis: `Precise controls. No accidental penalties.` converts better than generic `Relaxing brain puzzle.`

Primary metric:

- store listing conversion.

Guardrails:

- tutorial completion;
- D1 retention.

### Experiment B — Relax versus Challenge default

Hypothesis: Relax Mode as the default improves tutorial-to-Level-5 completion without reducing long-term mastery engagement.

Primary metric:

- Level 5 completion.

Guardrails:

- D1 retention;
- mode switching;
- average session length.

### Experiment C — Interstitial interval

Test only after retention is stable.

Compare:

- no interstitials;
- one after five completed levels;
- one after four completed levels with a time cooldown.

Primary metric:

- net revenue per new user.

Guardrails:

- D1/D7 retention;
- rating;
- session exits after ads.

### Experiment D — Main-menu hero

Compare final static artwork against a lightweight Living Board demonstration.

Primary metric:

- Continue/Start tap-through.

Guardrails:

- startup time;
- low-end device performance;
- Reduce Motion usability.

## Data review cadence

Daily during launch:

- crashes and ANRs;
- save failures;
- reward failures;
- severe funnel regressions.

Weekly:

- onboarding and level funnel;
- retention cohorts;
- touch fairness by device;
- review themes;
- monetization guardrails.

Monthly:

- chapter difficulty curve;
- content engagement;
- revenue by country;
- acquisition quality;
- event removal or schema revision.
