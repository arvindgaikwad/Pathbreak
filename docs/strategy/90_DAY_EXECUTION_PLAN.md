# Pathbreak — 90-Day Execution Plan

Last updated: 2026-08-06

## Objective

Turn the current working prototype into a measurable, testable Android puzzle game with a reliable content pipeline, 75 launch-quality levels, original presentation, closed-test readiness, and a clear go/no-go decision.

This plan assumes one primary developer using Godot with AI-assisted coding and documentation. It intentionally prioritizes product proof over feature volume.

## Non-negotiable outcomes by Day 90

- One supported gameplay architecture.
- Stable main menu, level select, gameplay, pause, settings, failure, and result flows.
- Level editor, schema validator, and solvability solver.
- At least 75 original, reviewed levels.
- Relax Mode and Challenge Mode behavior decided and implemented or staged explicitly.
- Analytics and crash reporting specification implemented for testing.
- Original launch art direction selected and consistently applied.
- Android release candidate tested on real devices.
- Closed test prepared with 12–30 testers.
- Privacy, store listing, support, and release documents drafted.

## Workstream ownership

### Product and game direction

- Define mechanic progression.
- Approve levels and difficulty curve.
- Protect the Fair, Readable, Calm, Fresh, and Respectful pillars.

### Engineering

- Gameplay stability.
- Level tooling.
- Save migration.
- Android lifecycle and performance.
- Analytics, ads, and purchase integration only at the planned stage.

### Art direction

- Final visual direction.
- Icon, logo, paths, board, menus, effects, and store assets.
- Accessibility and readability review.

### Publishing and business

- Play Console setup.
- Tester recruitment.
- Privacy and policy work.
- Marketing asset production.
- Revenue and retention reporting.

## Days 1–14 — Approve the vertical slice

### Product

- Complete and manually test Levels 1–5.
- Confirm each level has a single teaching purpose.
- Decide the first-session flow from launch through Level 5.
- Remove confusing temporary copy and dead states.

### Engineering

- Run parser scan and both validator suites.
- Test empty taps, ambiguous taps, rapid taps, pause during animation, and save/reload.
- Test common portrait viewports.
- Test at least one Android phone and one tablet.
- Fix all blocker and critical issues.

### Design

- Keep the current UI as a functional shell.
- Document visual problems without repeatedly redesigning screens.
- Create three visual-direction boards for the later art pass.

### Exit gate

- Levels 1–5 can be completed without assistance.
- No critical runtime or progress bug.
- Touch selection feels trustworthy.
- Tutorial completion from observed testers is at least 70%.

## Days 15–30 — Build the content factory

### Level editor

Required features:

- board-size control;
- draw, bend, select, move, and delete path;
- direction editing;
- undo/redo;
- save/load versioned JSON;
- direct playtest button;
- validation errors with highlighted cells.

### Validator

Reject:

- overlapping cells;
- non-adjacent cells;
- diagonal segments;
- invalid directions;
- duplicate IDs;
- out-of-bounds cells;
- unreadable spacing below chosen thresholds.

### Solver

Required outputs:

- solvable or unsolvable;
- one valid solution sequence;
- solution depth;
- number of initially valid choices;
- branching factor estimate;
- forced-move ratio.

### Exit gate

- A new valid level can be authored, tested, solved, scored, and exported without editing code.
- Automated tests cover editor output and solver basics.

## Days 31–50 — Produce and tune launch content

### Content target

- 5 tutorial/showcase levels.
- 20 easy levels.
- 25 normal levels.
- 20 hard levels.
- 5 mechanic showcase levels.

### Production batches

Produce in batches of 10:

1. Author or generate candidates.
2. Validate and solve.
3. Remove repetitive or visually ambiguous boards.
4. Human-play each level on a small phone.
5. Record intended difficulty and learning purpose.
6. Release only approved levels into the pack.

### Difficulty curve

- Levels 1–5: teach and establish trust.
- Levels 6–15: reinforce sequencing.
- Levels 16–30: introduce more bends and choice.
- Levels 31–50: increase planning depth without clutter.
- Levels 51–70: harder branching and efficiency.
- Levels 71–75: showcase challenges, not unfair density.

### Exit gate

- 75 levels pass schema and solver checks.
- No level relies on accidental touch difficulty.
- No obvious duplicate layouts.
- All levels have playtest notes.

## Days 51–65 — Product identity and retention

### Mode implementation

Relax Mode:

- no life loss;
- no forced timer;
- unlimited restart;
- optional hints.

Challenge Mode:

- limited mistakes;
- stars;
- best moves and time;
- replay for mastery.

### Retention foundation

- clear chapter map;
- recommended next level;
- chapter completion state;
- personal bests;
- new-content badge architecture;
- daily puzzle specification, but only implement when core progression is stable.

### Visual direction

Select one final direction after comparing three complete boards.

Apply it consistently to:

- main menu;
- level select;
- gameplay HUD;
- puzzle board and paths;
- pause/settings;
- result/failure;
- icon and store screenshots.

### Exit gate

- Game looks like one product rather than a collection of functional screens.
- Relax and Challenge differences are understandable.
- Final UI remains readable at 360 × 800.

## Days 66–75 — Measurement and monetization readiness

### Analytics

Implement the approved events from `ANALYTICS_AND_EXPERIMENTS_SPEC.md`.

Priority events:

- first open and session;
- tutorial and level funnel;
- blocked and ambiguous taps;
- hints and restarts;
- settings;
- crashes and save failures.

### Monetization sandbox

- Add rewarded-ad test placements.
- Add interstitial test placement after successful completion only.
- Add remove-ads test product.
- Verify reward callbacks, purchase restoration, and offline behavior.

Do not enable aggressive production ad frequency.

### Exit gate

- Test ads cannot corrupt progression.
- Reward success is measurable.
- Remove-ads state restores after reinstall/test restore.
- Privacy and Data Safety draft matches actual SDK behavior.

## Days 76–84 — Android QA and release preparation

### Device matrix

Test at minimum:

- low-end Android phone;
- mid-range phone;
- modern tall phone;
- small tablet;
- large tablet if available.

### Scenarios

- clean install;
- update over an older save;
- background/resume;
- force-stop and reopen;
- low-memory process death;
- offline launch;
- interrupted ad;
- interrupted purchase;
- incoming call/notification;
- Android back button;
- reduced motion and high contrast;
- corrupt save recovery.

### Store preparation

- final package name;
- signing key and backups;
- API target confirmed for submission date;
- privacy policy;
- Data Safety form draft;
- content rating;
- ads declaration;
- app icon, feature graphic, screenshots, short description, long description;
- support email and response templates.

### Exit gate

- Release candidate has no blocker or critical bug.
- Crash-free internal testing is above 99.5%.
- Store materials accurately represent the real game.

## Days 85–90 — Closed-test launch

### Recruit

- 12–30 testers.
- Include puzzle players, non-puzzle players, people aged 50+, and varied devices.
- Ensure policy-required testers remain opted in continuously for the required period where applicable.

### Test instructions

Ask testers to:

- play through at least Level 10;
- use Hint, Restart, Pause, settings, and both modes;
- report wrong-path taps;
- background and resume the app;
- test offline;
- submit a short feedback form.

### Dashboard

Review daily:

- crashes;
- tutorial funnel;
- per-level completion;
- ambiguous taps;
- hint and restart use;
- session length;
- tester feedback themes.

### Day-90 decision

Proceed toward soft launch when:

- no critical technical issue remains;
- most testers understand Level 1 without explanation;
- touch accuracy is trusted;
- at least half of testers reach Level 10;
- feedback supports the calm/precise positioning;
- the team can produce new levels consistently.

Return to product work when:

- tutorial confusion remains common;
- players describe the game as a clone with no reason to return;
- touch errors persist;
- content becomes repetitive early;
- crashes or progress loss remain unresolved.

## Weekly operating rhythm

### Monday

- Review evidence and choose one weekly outcome.

### Tuesday–Thursday

- Build and test the highest-priority product or tooling work.

### Friday

- Integrate, run automated tests, and prepare device build.

### Saturday

- Device testing, level playtesting, and tester observation.

### Sunday

- Update documents, risks, metrics, and next-week priorities.

## Scope protection

Do not add during these 90 days unless evidence changes the plan:

- multiplayer;
- accounts or cloud social systems;
- guilds or chat;
- complex currencies;
- story campaign production;
- 3D conversion;
- user-generated online level sharing;
- subscription;
- large paid marketing campaign.
