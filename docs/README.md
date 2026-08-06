# Pathbreak Documentation Index

**Last reviewed:** 2026-08-07

This file defines which documents should be trusted for the current build. A document's title or creation date alone does not make it current.

## Start here after a lost conversation

Read these files in order:

1. `PROJECT_HANDOFF.md` — current project state, decisions, commands, and continuation prompt.
2. `../TASKS.md` — prioritised execution checklist.
3. This documentation index.
4. `DECISIONS.md` and `AI_ANTI_SLOP_STANDARD.md`.
5. The latest playtest record and testing checklist.

## Source-of-truth order

1. Current code and automated tests on the active branch.
2. `PROJECT_HANDOFF.md` for the current recovery summary and continuation context.
3. `../TASKS.md` for execution order.
4. `VERTICAL_SLICE_REVIEW.md` for the approval gate and level status.
5. The latest dated vertical-slice playtest record.
6. `DECISIONS.md` for accepted architecture and product decisions.
7. `AI_ANTI_SLOP_STANDARD.md` for the production quality bar applied to AI-assisted work.
8. The focused specification documents below.
9. Historical pull-request descriptions and older conversation notes.

When documents disagree, update the stale document rather than guessing which statement is intended.

## Current documents

| Document | Status | Purpose |
|---|---|---|
| `PROJECT_HANDOFF.md` | Current recovery guide | Durable project context, commands, next actions, and new-chat prompt |
| `../TASKS.md` | Current tracker | Prioritised implementation, testing, design, content, and launch TODOs |
| `VERTICAL_SLICE_REVIEW.md` | Current | Approval criteria and Levels 1–5 review |
| `VERTICAL_SLICE_PLAYTEST_2026-08-06.md` | Current evidence | Observed playtest results and limitations |
| `DECISIONS.md` | Current | Architecture and product decision log |
| `AI_ANTI_SLOP_STANDARD.md` | Active standard | Quality gate for AI-assisted design, code, levels, writing, and verification |
| `GAME_DESIGN.md` | Current slice | Rules, connected loop, progression, roadmap |
| `TECHNICAL_PLAN.md` | Current slice | Runtime architecture, persistence, input, tests |
| `LEVEL_FORMAT.md` | Current | Canonical JSON authoring contract |
| `TESTING_CHECKLIST.md` | Current | Manual and automated verification matrix |
| `ART_DIRECTION.md` | Provisional | Current visual baseline; not final launch art |
| `PRODUCTION_WORKFLOW.md` | Process reference | Working method; implementation facts still require code verification |

## Important current facts

- Repository: `arvindgaikwad/Pathbreak`.
- Active branch: `codex/vertical-slice-level-review`.
- Active draft PR: `#8`.
- Godot 4.7.1, typed GDScript, Android portrait target.
- One modular gameplay architecture.
- JSON is the canonical level format; `.tres` is fallback only.
- The current production gate is a five-level vertical slice.
- Main Menu, Level Select, gameplay HUD, Pause/Settings, failure, result, and hint refill are part of the slice.
- The first incomplete Level 1 tutorial hint is free.
- Normal hints are persistent and consumable.
- At zero, the current testing build offers a functional `Refill +3` flow.
- The latest menu/path readability and automatic-final-clear implementation is pending local verification.
- AI-generated output must pass the anti-slop intent, craft, and verification checks.
- Parser warnings are defects and untested work must remain labelled unverified.
- Final art direction and launch monetization are not approved.

## Documentation maintenance rule

Every feature PR that changes player-visible behavior, save data, level format, architecture, or test requirements must update at least one relevant document and the testing checklist.

Use explicit labels such as:

- `Current`
- `Provisional`
- `Historical`
- `Superseded`
- `Pending verification`

Do not present untested implementation as verified behavior.
