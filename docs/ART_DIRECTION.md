# Pathbreak — Art Direction & UI System (Refined)

## 1. Vision & Palette (From UI Reference)
Pathbreak uses a soft, warm off-white cream background combined with pure white elevated cards, deep navy paths, and vibrant primary blue accents.

- **Canvas Background**: `#F8F6F0` (Warm soft cream)
- **Board Card & Containers**: `#FFFFFF` with 32px rounded corners, `#EFECE6` subtle borders, and soft ambient drop shadows.
- **Primary Paths & Text**: `#1B2538` (Deep navy)
- **Active Path Accent**: `#3B82F6` (Vibrant blue with tail dot & arrowhead)
- **Difficulty Pill**: `#EEF2FF` light lavender/blue with soft blue text ("Medium")
- **Error Flash**: `#EF5B5B` (Coral red)
- **Success / Stars**: `#F5A623` (Golden star rating)

## 2. Path Styling
- Paths are rendered with rounded joints (`Line2D`), a solid round dot at the tail (start cell), and a sleek arrowhead polygon at the head (exit tip).

## 3. Bottom Control Bar Layout
- Consists of 3 elevated white action cards with labels:
  - **Lives Card**: Heart icon `❤️` + count + label "Lives"
  - **Hint Card**: Lightbulb `💡` + count badge + label "Hint"
  - **Restart Card**: Refresh `↺` + label "Restart"

## 4. Victory Screen Pop-up Layout
- White pop-up card featuring a gold star badge at top, "Well done!" header, stats table (Time, Mistakes, Hints used), star rating, Replay button (outline), and Next Level button (vibrant blue `#2563EB`).
