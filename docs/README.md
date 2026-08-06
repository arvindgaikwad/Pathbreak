# Pathbreak Documentation Index

**Last reviewed:** 2026-08-07

This file defines which documents should be trusted for the current build. A document's title or creation date alone does not make it current.

## Start here after a lost conversation

Read these files in order:

1. `PROJECT_HANDOFF.md`
2. `../TASKS.md`
3. `ARROW_SYSTEM_AUDIT.md`
4. `SNAKE_ESCAPE_ANIMATION.md`
5. This index
6. `DECISIONS.md` and `AI_ANTI_SLOP_STANDARD.md`
7. Latest playtest and testing checklist

## Source-of-truth order

1. Current code and automated tests on the active branch.
2. `PROJECT_HANDOFF.md` for recovery context.
3. `../TASKS.md` for execution order.
4. `ARROW_SYSTEM_AUDIT.md` for the ordered path/head correction.
5. `SNAKE_ESCAPE_ANIMATION.md` for corner-following escape motion.
6. `VERTICAL_SLICE_REVIEW.md` for approval gates.
7. Latest dated playtest evidence.
8. `DECISIONS.md` and focused specifications.
9. Historical PR descriptions and old conversation notes.

When documents disagree, update the stale document rather than guessing.

## Current documents

| Document | Status | Purpose |
|---|---|---|
| `PROJECT_HANDOFF.md` | Current | Recovery guide, commands, next actions, continuation prompt |
| `../TASKS.md` | Current | Prioritised execution tracker |
| `ARROW_SYSTEM_AUDIT.md` | Current | Root cause, ordered-path migration, tests, risks |
| `SNAKE_ESCAPE_ANIMATION.md` | Pending verification | Corner-following escape animation and acceptance checks |
| `VERTICAL_SLICE_REVIEW.md` | Current | Approval criteria and Levels 1–5 review |
| `VERTICAL_SLICE_PLAYTEST_2026-08-06.md` | Current evidence | Playtest observations and verification boundaries |
| `DECISIONS.md` | Current | Architecture and product decisions |
| `AI_ANTI_SLOP_STANDARD.md` | Active standard | Quality gate for AI-assisted work |
| `GAME_DESIGN.md` | Current slice | Rules and progression |
| `TECHNICAL_PLAN.md` | Current slice | Runtime architecture and persistence |
| `LEVEL_FORMAT.md` | Current | Ordered tail-to-head JSON contract |
| `TESTING_CHECKLIST.md` | Current | Verification matrix |
| `ART_DIRECTION.md` | Provisional | Current visual baseline, not final art |
| `PRODUCTION_WORKFLOW.md` | Process reference | Working method |

## Important current facts

- Repository: `arvindgaikwad/Pathbreak`.
- Active branch: `codex/vertical-slice-level-review`.
- Active draft PR: `#8`.
- Godot 4.7.1, typed GDScript, Android portrait target.
- One modular gameplay architecture and one shared `PuzzlePiece` renderer.
- JSON is canonical; `.tres` is fallback only.
- Current path format is ordered `tail → ... → head`.
- Final segment direction equals arrowhead and movement direction.
- The user confirmed the parser/automated gate, movement regression gate, and new-player comprehension gate passed for the ordered-arrow correction.
- Static path visuals for Levels 2 and 5 were accepted.
- The latest unverified change is snake-like escape motion for bent paths.
- Reduce Motion keeps the simpler rigid translation/fade.
- Clean-save `FREE`, normal hint inventory, refill, restart, menu-board start, and automatic final clear were manually verified.
- AI-generated output must pass intent, craft, and verification checks.
- Parser warnings are defects.
- Final art direction and launch monetization are not approved.

## Documentation maintenance rule

Every change to player-visible behavior, level data, architecture, persistence, or testing must update the relevant document and checklist.

Use explicit labels:

- `Current`
- `Provisional`
- `Historical`
- `Superseded`
- `Pending verification`

Never present untested implementation as verified.
