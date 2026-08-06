# Pathbreak — Monetization and Earnings Plan

Last updated: 2026-08-06

## Principle

Pathbreak should monetize after it proves that players enjoy returning. Ads cannot rescue weak retention; they only increase churn.

The launch model should be free-to-play with respectful advertising and one permanent purchase. Do not launch with subscriptions, loot boxes, energy timers, or a complicated economy.

## Version 1 monetization

### Rewarded ads

Voluntary uses:

- Gain one hint.
- Continue after losing all Challenge Mode lives.
- Double a small post-level reward later.
- Try a cosmetic theme temporarily later.

Rules:

- Reward must be granted reliably after the ad-completion callback.
- Never show a rewarded ad automatically.
- Offer a non-ad path where practical.
- Log requested, started, completed, failed, and reward-granted states separately.

### Interstitial ads

Initial cap:

- No interstitials during Levels 1–10.
- Only after successful level completion.
- Approximately one after every 4–5 completed levels at most.
- Never after failure.
- Never between rapid retries.
- Never immediately after a rewarded ad.
- Include a cooldown based on time as well as completed levels.

### Remove Ads purchase

Recommended first price tests:

- India: ₹149, ₹199, or ₹249.
- Higher-income markets: localized equivalent around US$2.99–4.99.

Definition:

- Removes forced interstitial and banner advertising permanently.
- Rewarded ads remain optional because they provide value chosen by the player.
- Purchase restoration must work.
- The offer should appear after the player has experienced the game, not on first launch.

### Optional later purchases

Only after retention is proven:

- Hint packs.
- Cosmetic board themes.
- Chapter packs with substantial original content.
- Supporter bundle containing remove-ads plus cosmetics.

Avoid selling solutions so aggressively that the puzzles feel designed to create frustration.

## Earnings cannot be predicted from installs alone

Required variables:

- Monthly active users.
- Daily active users.
- Sessions per user.
- Ads shown per session.
- Fill rate.
- Effective CPM by country and format.
- Rewarded-ad opt-in rate.
- Purchase conversion.
- Average purchase value.
- Store fees, tax, refunds, and advertising cost.

No public source currently discloses these variables for direct competitors. Revenue scenarios below are planning models, not forecasts.

## Scenario model

### Core assumptions

Use these only for early planning:

- DAU/MAU ratio: 15%–25%.
- Average sessions per DAU: 1.5–2.5.
- Monetized impressions per session: 0.3–1.2, depending on ad policy.
- Blended net ad revenue per 1,000 impressions: highly geography-dependent; model ₹40–₹250 after mediation uncertainty.
- Remove-ads conversion: 0.2%–1.5% of monthly active users.
- Net purchase revenue after platform share and taxes: model at 65%–80% of gross until actual reports exist.

### Small validated game

Assume:

- 10,000 monthly active users.
- 2,000 daily active users.
- 2 sessions per DAU.
- 0.6 monetized impressions per session.
- 30 days.

Estimated monthly impressions:

`2,000 × 2 × 0.6 × 30 = 72,000`

At a blended net ₹40–₹250 eCPM:

- Ads: approximately ₹2,880–₹18,000 per month.

At 0.2%–1.0% remove-ads conversion, ₹199 gross price, and 70% net receipt:

- Buyers: 20–100.
- Purchase net: approximately ₹2,786–₹13,930.

Planning range before operating expenses:

- Approximately ₹5,000–₹32,000 per month.

### Growing niche game

Assume:

- 100,000 monthly active users.
- 20,000 daily active users.
- Same session and impression assumptions.

Estimated monthly impressions:

`20,000 × 2 × 0.6 × 30 = 720,000`

- Ads at ₹40–₹250 eCPM: approximately ₹28,800–₹180,000.
- Remove-ads at 0.2%–1.0% conversion: approximately ₹27,860–₹139,300 net.

Planning range before expenses:

- Approximately ₹57,000–₹319,000 per month.

### Strong global game

Assume:

- 1,000,000 monthly active users.
- 200,000 daily active users.

Estimated monthly impressions:

`200,000 × 2 × 0.6 × 30 = 7,200,000`

- Ads at ₹40–₹250 eCPM: approximately ₹288,000–₹1,800,000.
- Remove-ads at 0.2%–1.0% conversion: approximately ₹278,600–₹1,393,000 net.

Planning range before expenses:

- Approximately ₹0.57 million–₹3.19 million per month.

This scenario is difficult and requires strong retention, international distribution, content operations, and often paid acquisition.

## Costs to include

### Fixed and development costs

- Google Play developer registration.
- Test devices.
- Original icon, store art, audio, and fonts/licenses.
- Privacy policy and legal review if needed.
- Analytics, crash reporting, and backend costs if free tiers are exceeded.
- Contractor or localization costs.

### Variable costs

- User acquisition.
- Mediation or analytics services if paid.
- Taxes and accounting.
- Refunds and chargebacks.
- Ongoing content production.
- Customer support.

## Decision gates

### Before adding interstitials

Require:

- Tutorial completion above 75%.
- Stable progression through Level 10.
- Crash-free users above 99.5%.
- No common touch-selection complaints.

### Before paid acquisition

Require two consecutive cohorts near these directional gates:

- Day-1 retention around 30% or better.
- Day-7 retention around 7% or better.
- Average rating above 4.3.
- Store conversion and monetization measured by country.

### Before adding more IAP

Require evidence that players ask for:

- More hints.
- More themes.
- More chapters.
- A way to support the game.

Do not invent an economy merely because competitors have one.

## Revenue dashboard

Track weekly:

- DAU and MAU.
- D1, D7, and D30 retention.
- Sessions per DAU.
- Level completion funnel.
- Rewarded requests and completion rate.
- Interstitial impressions per DAU.
- Ad revenue per DAU and per MAU.
- Purchase conversion.
- Average revenue per daily active user.
- Refund rate.
- Revenue by country.
- Revenue after user-acquisition spend.

## Financial rule

Treat gross store revenue as business revenue only after subtracting platform fees, taxes, refunds, user acquisition, contractors, tools, and ongoing content costs.

## Source context

The mobile free-to-play market commonly combines advertising and optional purchases. Research on mobile monetization also shows that a small share of buyers can contribute a large portion of purchase revenue, which is why Pathbreak must not design the experience around unrealistic average-player spending.

Research reference: https://arxiv.org/abs/2312.10205
