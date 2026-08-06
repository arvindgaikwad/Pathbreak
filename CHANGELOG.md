# Pathbreak — Changelog

## [0.2.0] - 2026-08-06

### Added
- **UI Redesign matching Reference Image**:
  - **Path Tail Dots**: Added solid round dot rendering (`_draw_tail_dot()`) at the start cell of each path line (`cells[0]`) matching Screen 1.
  - **Action Control Cards**: Redesigned bottom bar with 3 elevated white cards: "Lives" (`❤️ 3`), "Hint" (`💡` + blue badge `2`), and "Restart" (`↺`).
  - **Header & Title Bar**: Centered "Level X" title with "Medium" difficulty pill below it, circular back button (`←`), settings button (`⚙`), and subtitle "Clear all paths".
  - **Level Select Overhaul**: World progress card ("Progress 36 / 120", `30%`), World section title ("World 1 · Beginnings"), 4-column level grid with level numbers and star ratings.
  - **Victory Overlay Overhaul**: Floating gold star `⭐` badge, "Well done!" header, stats table (Time `00:45`, Mistakes `0`, Hints used `1`), star rating, outline Replay button, and vibrant blue Next Level button (`#2563EB`).
  - **Palette Update**: Warm cream canvas `#F8F6F0`, pure white 32px rounded cards `#FFFFFF`, deep navy `#1B2538`, vibrant blue `#3B82F6` / `#2563EB`.

### Fixed
- Fixed node paths in `scripts/ui/hud.gd`.
- Verified 0 errors across 5 portrait resolutions: 360×800, 393×873, 412×915, 800×1280, 1200×1920.
