# Pathbreak — Launch Plan

Last updated: 2026-08-06

## Launch objective

Release a stable Android puzzle game with enough content and measurement to learn whether Pathbreak deserves continued investment. The first release is a controlled market test, not the final destination.

## Launch prerequisites

### Product

- 75 original, solver-verified, human-reviewed levels.
- Levels 1–5 form a polished tutorial and showcase.
- Relax Mode and Challenge Mode or a clearly documented staged rollout.
- Reliable Hint, Restart, Pause, Replay, Next Level, and save flows.
- No dead buttons or placeholder purchases.
- Original name, icon, store artwork, audio, and UI identity.

### Technical

- Target Android 16 / API 36 for submissions from 31 August 2026 onward.
- Android App Bundle export.
- Signed release build and protected signing key backup.
- Crash reporting and analytics enabled only after consent/policy review.
- Tested app pause/resume, low memory, rotation lock, back button, notifications interruptions, and offline play.
- Crash-free users target above 99.5% in testing.
- No progression-loss or purchase-restoration bugs.

### Store and policy

- Privacy policy.
- Data Safety form.
- Content rating questionnaire.
- Ads declaration.
- Target audience declaration.
- App access instructions if required.
- Store listing text and localized assets.
- Package name finalized before publication.

## Google Play testing requirement

For a personal developer account created after 13 November 2023, Google currently requires a closed test with at least 12 testers continuously opted in for 14 days before applying for production access.

Official source:
https://support.google.com/googleplay/android-developer/answer/14151465

## Recommended release stages

### Stage 0 — Internal QA

Duration: 1–2 weeks.

Participants:

- Developer.
- Cofounder/friends.
- 3–5 reliable device testers.

Goals:

- Zero parser/runtime errors.
- Validate progression and save migration.
- Test at least five low/mid/high Android devices.
- Complete all levels.
- Verify every level is solvable and has intended difficulty.

Exit criteria:

- No blocker or critical bug.
- No lost save.
- No recurring touch-selection issue.

### Stage 1 — Closed test

Duration: minimum 14 days where policy applies; prefer 2–3 weeks.

Participants:

- 12–30 testers.
- Mix of puzzle players and non-puzzle players.
- Include older users and small-screen devices.

Collect:

- Private Play feedback.
- Screen recordings for confusion points.
- Tutorial completion.
- Per-level failure and hint rates.
- Device performance and crash data.
- Ad and purchase tests using test products only.

Exit criteria:

- Tutorial completion above 75%.
- Most testers reach at least Level 10.
- No critical crash or progression issue.
- Clear evidence that touch accuracy is trusted.

### Stage 2 — Limited production / soft launch

Recommended countries:

- India for accessible testing and local feedback.
- One English-speaking market with higher ad value, chosen only when support and localization are ready.
- Optionally one lower-cost acquisition market for creative testing.

Do not launch globally on day one if analytics, support, and content cadence are unproven.

Duration: 3–6 weeks.

Goals:

- Measure D1 and D7 retention.
- Find the exact level where players leave.
- Validate store conversion.
- Validate ad tolerance and purchase conversion.
- Compare Relax versus Challenge behaviour.

### Stage 3 — Global release

Proceed only when:

- D1 retention is near or above 30% for two cohorts.
- D7 retention is near or above 7% for two cohorts.
- Rating is above 4.3.
- Crash-free users are above 99.5%.
- Content production can support weekly updates.
- Monetization does not produce a clear retention drop.

## Store listing plan

### Name and short description

Do not use a final name until trademark screening is complete.

Positioning themes to test:

- Relaxing directional puzzle.
- Precise tap-away logic game.
- Offline brain puzzle.
- No-timer logic challenge.

### Screenshot sequence

1. Core gameplay with a readable clear move.
2. Precise controls / no accidental penalties.
3. Relax Mode without lives or timers.
4. Challenge Mode with stars and efficiency.
5. Original chapter mechanics.
6. Offline play and progress.

### Store experiments

Test one variable at a time:

- Icon.
- First screenshot.
- Short description.
- Video versus no video.

Google Play supports custom store listings for country, keyword, pre-registration, and other user segments. Use this after sufficient traffic exists.

Official source:
https://support.google.com/googleplay/android-developer/answer/9867158

## Organic launch content

Prepare before release:

- 20 short vertical gameplay clips.
- 10 “Find the first move” posts.
- 5 satisfying full-board clears.
- 3 development-story posts.
- 3 accessibility/precision demonstrations.
- Store trailer under 30 seconds.

Channels:

- Instagram Reels.
- YouTube Shorts.
- TikTok where available and appropriate.
- Reddit communities where self-promotion rules permit.
- Indie-game communities.

The video should show gameplay within the first second. Avoid long logos and generic cinematic intros.

## Paid acquisition plan

Do not buy large campaigns at launch.

Initial test:

- 3–5 creatives.
- Small daily budget.
- Separate country campaigns.
- Measure install cost, tutorial completion, D1 retention, and revenue by creative.

Stop campaigns that produce cheap installs but weak retention.

## Launch calendar

### T-8 to T-6 weeks

- Freeze core mechanics.
- Finish editor/solver pipeline.
- Complete first 50 levels.
- Draft privacy and store materials.

### T-6 to T-4 weeks

- Complete 75 levels.
- Add analytics and crash reporting.
- Run internal QA.
- Produce icon, screenshots, video, and localization.

### T-4 to T-2 weeks

- Closed testing.
- Fix tutorial, crashes, touch issues, and difficulty spikes.
- Test ads and purchases in sandbox.

### T-2 to launch

- Submit production-access application if required.
- Final policy review.
- Build release candidate.
- Prepare social content and support responses.

### Launch week

- Staged rollout where possible.
- Monitor crashes, reviews, level funnel, and ads daily.
- Respond to support issues quickly.
- Avoid adding new systems during launch week.

### First 30 days

- Weekly bug-fix release only when necessary.
- Add one curated level pack.
- Run first store-listing test.
- Publish short-form content consistently.
- Decide whether to expand countries or pause for product work.

## Post-launch cadence

- Daily: monitor crashes, revenue anomalies, and reviews.
- Weekly: 5–10 curated levels, balance fixes, support summary.
- Monthly: themed pack or mechanic variation, store-art refresh test.
- Quarterly: larger chapter, retention review, monetization review.

## Go / no-go rule

Continue serious investment when Pathbreak shows repeatable retention and positive player feedback about fairness, readability, and satisfaction. Pause paid growth and return to product work when installs do not convert into retained players.

## Official references

- Testing requirement: https://support.google.com/googleplay/android-developer/answer/14151465
- Test tracks: https://support.google.com/googleplay/android-developer/answer/9845334
- Target API: https://support.google.com/googleplay/android-developer/answer/11926878
- Custom listings: https://support.google.com/googleplay/android-developer/answer/9867158
- Pre-registration: https://support.google.com/googleplay/android-developer/answer/9859047
