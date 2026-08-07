# Pathbreak — Completion Finish v2

**Status:** Implemented on `codex/satisfaction-prototype-v1`; pending local regression and director feel verification  
**Date:** 2026-08-07

## Goal

Make the final automatic clear feel like a mechanism finishing itself, without turning the end of a level into a generic celebration or adding delay.

Locked rule:

> **The finish may reward completion, but it must not teach the next answer because there is no next answer left to teach.**

## Sequence

Normal motion target:

```text
second-last chosen path finishes escaping
→ final path gives a short whole-path readiness breath
→ final path auto-releases using the accepted Release Polish v2 motion
→ tiny whole-board settle
→ completion sound + haptic
→ result screen
```

The final preview no longer uses the travelling direction marker associated with hints. It is a non-directional whole-path activation.

## Timing target

The finish from final-preview start to result presentation is intentionally kept inside roughly **400–700 ms** for full motion.

Current designed budget:

- final readiness preview: ~90 ms;
- final Release Polish v2 escape: ~285 ms;
- coordinator gap after escape: 15 ms;
- board settle: ~180 ms;
- total: ~570 ms.

Reduce Motion keeps a much shorter path:

- readiness state: ~40 ms;
- short translation/fade: 180 ms;
- coordinator/result gaps: ~55 ms;
- no board scale settle;
- target remains under 300 ms.

These are implementation targets, not claimed measured runtime results until the local tests are run.

## Behavior changes

- Removed the long ~440 ms final-direction preview.
- Final auto-clear now begins as soon as the second-last release animation has finished plus a tiny 15 ms handoff gap.
- Final completion waits on the final piece's actual configured escape duration rather than a hard-coded 300 ms timer.
- The repeated `Last path clears itself` message is now limited to the fresh Level 1 tutorial instead of appearing on every level.
- Board settle was shortened and softened.
- Result UI waits for the settle to finish in full motion.
- Rejected newly-freed answer cues remain disabled.
- The obsolete unlock-audio hook was removed.

## Automated safeguards

`tests/test_completion_finish.gd` adds three checks:

1. full-motion finish stays inside the 400–700 ms design budget;
2. Reduce Motion finish stays under 300 ms;
3. final auto-clear preview does not reuse the travelling hint marker.

The Android regression helper now includes:

- `tests/test_satisfaction_feedback.gd`
- `tests/test_release_polish.gd`
- `tests/test_completion_finish.gd`

## Manual director check

Use Levels 3–5 and focus only on the last two paths.

Pass when:

- the second-last manual choice feels complete before the final path begins;
- the final path visibly prepares but does not feel like a Hint animation;
- final snake/straight motion keeps the already-approved speed;
- board settle is visible only as a subtle finish, not a bounce;
- result screen arrives quickly enough that replaying levels never feels slow;
- completion sound/haptic feels attached to the finish rather than firing early;
- Reduce Motion remains clear and much shorter;
- no remaining path is highlighted during normal gameplay.

Reject or reduce the finish if it feels theatrical, slow, bouncy, noisy, or if the result card seems to wait for animation rather than follow it naturally.

## Next gate

After automated regression and director feel verification pass, stop adding satisfaction mechanics and run the planned three-person satisfaction/readability test before locking the Pathbreak feel language.
