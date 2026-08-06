# Pathbreak Documentation Index

**Last reviewed:** 2026-08-06

This file defines which documents should be trusted for the current build. A document's title or creation date alone does not make it current.

## Source-of-truth order

1. Current code and automated tests on the active branch.
2. `VERTICAL_SLICE_REVIEW.md` for the approval gate and level status.
3. The latest dated vertical-slice playtest record.
4. `DECISIONS.md` for accepted architecture and product decisions.
5. The focused specification documents below.
6. Historical pull-request descriptions and older conversation notes.

When documents disagree, update the stale document rather than guessing which statement is intended.

## Current documents

| Document | Status | Purpose |
|---|---|---|
| `VERTICAL_SLICE_REVIEW.md` | Current | Approval criteria and Levels 1–5 review |
| `VERTICAL_SLICE_PLAYTEST_2026-08-06.md` | Current evidence | Observed playtest results and limitations |
| `DECISIONS.md` | Current | Architecture and product decision log |
| `GAME_DESIGN.md` | Current slice | Rules, connected loop, progression, roadmap |
| `TECHNICAL_PLAN.md` | Current slice | Runtime architecture, persistence, input, tests |
| `LEVEL_FORMAT.md` | Current | Canonical JSON authoring contract |
| `TESTING_CHECKLIST.md` | Current | Manual and automated verification matrix |
| `ART_DIRECTION.md` | Provisional | Current visual baseline; not final launch art |
| `PRODUCTION_WORKFLOW.md` | Process reference | Working method; implementation facts still require code verification |

## Important current facts

- Godot 4.7.1, typed GDScript, Android portrait target.
- One modular gameplay architecture.
- JSON is the canonical level format; `.tres` is fallback only.
- The current production gate is a five-level vertical slice.
- Main Menu, Level Select, gameplay HUD, Pause/Settings, failure, result, and hint refill are part of the slice.
- The first incomplete Level 1 tutorial hint is free.
- Normal hints are persistent and consumable.
- At zero, the current testing build offers a functional `Refill +3` flow.
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
