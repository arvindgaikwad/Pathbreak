# Pathbreak — Risks, Missing Work, and Strategic Decisions

Last updated: 2026-08-06

## Purpose

This document captures important areas that are often missed when a solo developer focuses mainly on coding and UI.

## Market risks

### Crowded category

Risk:

- The basic mechanic is easy to understand and easy for competitors to imitate.
- Search results already contain many similar names, screenshots, and claims.

Mitigation:

- Build original chapter mechanics.
- Own precision, accessibility, and respectful monetization.
- Develop a level-production advantage.
- Avoid generic naming such as another “Arrow Away” variation.

### Dominant competitor distribution

Risk:

- Easybrain has a major existing puzzle portfolio and a 10M+ Google Play install signal for its direct title.
- A solo game cannot initially match its advertising reach or content volume.

Mitigation:

- Compete on a narrow promise.
- Use organic satisfying-game videos.
- Soft launch and improve retention before paid acquisition.
- Do not compete solely on “more levels.”

### Weak differentiation

Risk:

- A polished clone may still fail because players already have alternatives.

Mitigation:

- Require every chapter to introduce a meaningful original rule.
- Test whether players can describe what makes Pathbreak different.

## Legal and originality risks

### Copyright and trade dress

Risk:

- Copying another game's screen composition, art, level layouts, animation sequence, tutorial language, icons, sounds, or store assets may create legal and platform risk.

Mitigation:

- Create all levels independently.
- Maintain art-direction and design-decision documentation.
- Use original code and assets.
- Preserve development history in Git.
- Do not trace screenshots.

### Trademark and naming

Risk:

- “Pathbreak” is a working name and may conflict with existing marks or products.

Mitigation:

- Run a proper trademark and app-store name search before final branding.
- Check relevant software/game classes and primary launch countries.
- Do not spend heavily on branding before clearance.

### Patents

Risk:

- Game mechanics are often difficult to protect through copyright, while patents can create separate concerns.

Mitigation:

- Conduct a professional clearance review before a large commercial launch when budget allows.
- Document independently developed mechanics.

## Product risks

### Repetitive content

Risk:

- Large level counts can still feel repetitive.

Mitigation:

- Give every level a purpose.
- Introduce mechanics gradually.
- Use solver metrics plus human review.
- Track level abandonment.

### Poor first-session experience

Risk:

- Players leave before understanding the rule or experiencing satisfaction.

Mitigation:

- Level 1 teaches through play.
- Keep first session ad-free.
- Reach a satisfying completion quickly.
- Test with people who have not seen development.

### Difficulty spikes

Risk:

- Designer intuition alone produces inconsistent difficulty.

Mitigation:

- Measure solution depth, branching, density, hints, failures, and restarts.
- Combine simulation and real player analytics.

### No return reason

Risk:

- Players finish several levels and do not return.

Mitigation:

- Chapter progression.
- Daily puzzle after core launch.
- Weekly content.
- Clear next goal without manipulative pressure.

## Technical risks

### Save loss

Risk:

- Progress loss creates immediate one-star reviews.

Mitigation:

- Versioned saves.
- Backup and recovery.
- Corrupt-file handling.
- Migration tests.
- Save after meaningful progression events.

### Touch ambiguity

Risk:

- Dense boards select the wrong path.

Mitigation:

- Nearest-path selection.
- Larger invisible hit areas.
- Ambiguity detection and no penalty.
- Small-device testing.
- Minimum-spacing validation.

### Device fragmentation

Risk:

- Android devices vary widely in aspect ratio, memory, GPU, input, and OS version.

Mitigation:

- Test low, mid, and high-end devices.
- Support multiple portrait sizes.
- Use the compatibility/mobile renderer appropriately.
- Monitor Android vitals.

### Ads and purchases fail

Risk:

- Rewarded ads do not grant rewards or purchases are not restored.

Mitigation:

- Server-validated purchase state where appropriate.
- Idempotent reward granting.
- Separate ad completion from reward confirmation.
- Sandbox and interruption testing.

## Financial risks

### Revenue optimism

Risk:

- Install numbers are mistaken for active users or earnings.

Mitigation:

- Use cohort-based revenue models.
- Treat scenarios as estimates.
- Track net revenue after fees, taxes, refunds, acquisition, and operations.

### Paid acquisition before retention

Risk:

- Money buys users who immediately leave.

Mitigation:

- Require retention gates before scaling ads.
- Measure value by country and creative.
- Stop campaigns that fail downstream metrics.

### Ongoing content cost

Risk:

- The game launches but cannot maintain a content cadence.

Mitigation:

- Build editor, solver, and validation before launch.
- Establish a four-week content buffer.

## Operational risks

### No customer support process

Risk:

- Reviews and purchase issues go unanswered.

Mitigation:

- Support email.
- Issue categories and response templates.
- Weekly review summary.
- Priority for lost progress, purchases, crashes, and ads.

### No release discipline

Risk:

- Unrelated features are added during urgent bug fixing.

Mitigation:

- Release branches.
- Changelog.
- Regression checklist.
- Staged rollout.
- Emergency rollback plan.

### Single-person dependency

Risk:

- Development stops if the owner is unavailable.

Mitigation:

- Clear documentation.
- Automated tests.
- Repeatable build instructions.
- Backups of signing keys and accounts.

## Important missing documents and systems

These should be created before launch:

- Final game design document.
- Level design handbook.
- Analytics event specification.
- Privacy/data inventory.
- Accessibility checklist.
- Android release checklist.
- Customer-support playbook.
- Store asset specification.
- Localization glossary.
- QA test matrix.
- Incident and rollback plan.
- Signing-key backup procedure.
- Trademark/name-clearance record.
- Content calendar.

## Strategic decisions recorded

### Decision 1 — Android first

Reason:

- Current Godot project and available devices are Android-focused.
- Shipping one platform well is preferable to splitting effort.

### Decision 2 — Offline core game

Reason:

- Reduces cost and complexity.
- Supports the target relaxation use case.
- Accounts and cloud saves can be evaluated later.

### Decision 3 — Respectful free-to-play

Reason:

- Free entry helps a new brand acquire users.
- Rewarded ads and remove-ads can monetize without aggressive pressure.

### Decision 4 — Retention before scaling

Reason:

- Paid acquisition and monetization are wasteful before the product proves repeat use.

### Decision 5 — UI shell now, full art overhaul later

Reason:

- Current UI is functional for testing.
- Final visual production should happen after level systems, content structure, and market positioning stabilize.

### Decision 6 — Tooling before 75 levels

Reason:

- Manual level production without a validator and solver creates unsolvable content, inconsistent difficulty, and wasted work.

## Review cadence

Review this document:

- At the end of each milestone.
- Before adding monetization.
- Before closed testing.
- Before production release.
- After the first 30 days in market.
