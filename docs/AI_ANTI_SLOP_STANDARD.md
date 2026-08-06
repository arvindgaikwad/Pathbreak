# Pathbreak — AI Anti-Slop Quality Standard

**Status:** Active production standard  
**Last reviewed:** 2026-08-06

## Purpose

AI can accelerate implementation, but it must not lower authorship, clarity, reliability, or taste. Pathbreak should feel intentionally directed by a game team, not assembled from generic AI defaults.

“AI slop” in this project means any output that is technically present but weakly reasoned, generic, inconsistent, unverified, repetitive, misleading, or disconnected from the player experience.

This standard applies to code, levels, UI, art, motion, audio, writing, documentation, marketing, and production decisions.

## Core rule

Every addition must answer four questions:

1. What player or production problem does this solve?
2. Why is this solution appropriate for Pathbreak specifically?
3. What evidence or acceptance criteria prove it works?
4. What unnecessary complexity, imitation, or filler was removed?

A feature that cannot answer these questions is not ready to enter production.

## 1. Game-design standard

- Levels must create meaningful decisions, not merely contain more pieces.
- Difficulty must come from readable dependency structure, not visual clutter or unfair ambiguity.
- New mechanics require a teaching level, a combination level, and a validation plan.
- Features must support the central promise: fair, readable, calm directional-path solving.
- Do not add daily rewards, currencies, streaks, events, shops, or social systems simply because other mobile games contain them.
- Do not confuse content volume with game depth.

### Rejection signals

- Thousands of solution orders with no meaningful sequencing.
- Busy boards that solve themselves through random tapping.
- Difficulty labels unsupported by playtest evidence.
- Mechanics added only to make a feature list look larger.

## 2. UI and visual standard

- Every screen needs one clear primary action and a deliberate information hierarchy.
- Avoid generic SaaS composition, excessive white cards, arbitrary gradients, glass effects, oversized rounded rectangles, and decorative icons without gameplay meaning.
- Do not use emoji as final production icons.
- Typography, spacing, corner radii, shadows, icon weight, and motion must follow a coherent system.
- Decoration must reinforce navigation, state, puzzle readability, or brand identity.
- The final visual identity must include at least one ownable motif beyond a color palette.
- Reference competitors to understand expectations, never to reproduce trade dress or screen composition.

### Rejection signals

- A screen could belong to any unrelated productivity app.
- Every element is placed inside a card.
- Random blue accents are used without semantic meaning.
- Placeholder icons or copy survive into a review build without being labelled provisional.
- Visual polish hides weak interaction design.

## 3. Code standard

- Use typed GDScript for parameters, return values, state, and ambiguous local expressions.
- Parser warnings are treated as defects, not harmless noise.
- Do not duplicate systems, scenes, managers, or sources of truth.
- Separate gameplay rules from rendering, animation, and UI.
- Preserve modular boundaries and existing working behaviour unless a decision record approves a change.
- Handle empty, invalid, interrupted, repeated-input, and recovery states.
- Add tests for deterministic rules and manual acceptance steps for player-facing flows.
- Do not claim code works until it has been parsed and exercised in the required environment.

### Rejection signals

- Untyped Variant chains where strict typing is practical.
- Large scripts mixing save data, UI construction, rules, monetization, and scene navigation.
- Copy-pasted handlers with small differences.
- Silent fallbacks that hide invalid data.
- “Implemented” used as a synonym for “verified.”

## 4. Documentation standard

- Documents must declare whether they are Current, Provisional, Historical, Superseded, or Pending verification.
- Current code and tests outrank stale prose.
- Decisions must include context, decision, rationale, status, and consequences.
- Do not use inflated claims, invented metrics, or confident language unsupported by evidence.
- Avoid repetitive filler, generic advice, and long lists that do not change a production decision.
- Update the relevant document when behaviour, architecture, save data, level format, or test requirements change.

## 5. Writing and UX-copy standard

- Use short, concrete language appropriate to a calm puzzle game.
- Buttons describe actions: `Continue`, `Replay`, `Refill 3 Hints`, `Try Again`.
- Avoid vague motivational filler, fake urgency, excessive exclamation marks, and manipulative scarcity.
- Do not explain obvious interface elements with unnecessary text.
- Error messages state what happened and what the player can do next.

## 6. Monetization standard

- Monetization must preserve puzzle flow and player trust.
- No ad or purchase decision is approved without a player benefit, trigger rule, frequency limit, fallback, analytics event, and removal option where appropriate.
- Rewarded actions must be genuinely optional.
- Never create a problem solely to sell its solution.
- The current free hint refill is a testing mechanism, not an approved launch economy.

## 7. AI-assisted production workflow

Every AI-generated contribution goes through these passes:

### Pass A — Intent

- State the exact objective.
- Identify affected systems and player states.
- Confirm the work supports an approved milestone.

### Pass B — Craft

- Replace generic defaults with Pathbreak-specific decisions.
- Remove placeholders, duplicated logic, decorative filler, and unnecessary features.
- Check consistency with architecture, interaction, and visual rules.

### Pass C — Verification

- Run parser checks and automated tests.
- Perform the manual flow on the intended viewport or device.
- Capture evidence for visual or interaction decisions.
- Record limitations and unverified assumptions.

## 8. Pull-request anti-slop checklist

A player-facing PR is not ready until all applicable statements are true:

- [ ] The problem and intended player outcome are explicit.
- [ ] The change supports the current milestone.
- [ ] No duplicate architecture or source of truth was introduced.
- [ ] Strict parser checks pass without new warnings.
- [ ] Automated tests pass.
- [ ] Empty, failure, cancel, retry, persistence, and navigation states were considered.
- [ ] UI has a clear primary action and no unexplained decoration.
- [ ] Placeholder emoji, generic copy, and temporary visuals are removed or labelled provisional.
- [ ] The result is recognisably Pathbreak rather than a generic template.
- [ ] Documentation matches the implementation.
- [ ] Untested work is described as unverified.

## Current application to the vertical slice

For the present milestone, this standard means:

- approve Levels 1–5 through structure analysis and real playtests;
- keep the current light UI provisional;
- fix all parser warnings immediately;
- verify hint depletion, refill, cancellation, persistence, and statistics;
- avoid adding launch economies, live operations, or decorative systems before the core slice passes;
- replace temporary emoji and generic visual treatments during the dedicated art-direction phase.
