# Pathbreak — Testing Checklist

## 1. Automated Test Cases (MovementValidator Unit Tests)
- [ ] Test 1: Unblocked straight path (should return `true`).
- [ ] Test 2: Blocked straight path (should return `false`).
- [ ] Test 3: Bent path blocked through one of its bend cells (should return `false`).
- [ ] Test 4: Path touching board edge facing outwards (should return `true`).
- [ ] Test 5: Path whose own cells appear ahead of another cell along the ray (self-occupancy check, should return `true` if no external blocker).
- [ ] Test 6: Two blockers in the same exit direction (should return `false`).
- [ ] Test 7: Occupancy dictionary updated correctly after path removal.
- [ ] Test 8: Occupancy dictionary reconstructed cleanly after board restart.
- [ ] Test 9: Rapid repeated tap protection on escaping piece.
- [ ] Test 10: Final path completion triggers level complete.

## 2. Portrait Viewport Scaling Checklist
- [ ] 360 × 800 (Compact mobile)
- [ ] 393 × 873 (Standard mobile)
- [ ] 412 × 915 (Tall mobile)
- [ ] 800 × 1280 (Tablet portrait)
- [ ] 1200 × 1920 (High-res tablet)
