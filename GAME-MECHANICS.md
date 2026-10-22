# Current Game Mechanics

Compiled from the current implementation in `index.html`. This describes what the code does today, including behaviors that may be bugs or design decisions to revisit.

## At a glance

The main journey has six game types, each with three ordered levels, followed by a code-gated final quiz:

1. Word Puzzle — 3 routes
2. Baby Delivery Maze — 3 routes
3. Fix the Broken Delivery — 3 scenarios
4. Detective Investigation — 3 cases
5. Flip n Match — 3 card-grid sizes
6. Spot & Fix the Errors — 3 inspection levels
7. Final Delivery — seminar-code gate and 2-question quiz

Stops are played in sequence on the delivery map. Completing a stop records its score and advances the courier. Gates between game types can require host authorization. Clearing the final challenge shows the evaluation/certificate card.

## Shared progression and scoring

- Each completed game stop records points and awards 1–3 stars based on score divided by that stop's maximum: 3 stars at 85% or higher, 2 at 60% or higher, otherwise 1.
- Replaying an already passed stop is no additional points or score overrides are awarded to the player's total.
- Some games have their own maximum score per difficulty (usually 450, 480, then 500). The stage data itself labels all game stops with a 500-point cap, so star thresholds can differ from the game's displayed maximum.
- The Next Stop control can complete an unfinished non-gate stop with a fallback score of 250. This means a player may advance without meeting that game's normal win condition.
- Gate authorization is separate from game completion and can be released by the host/control system. A demo-unlock control is also available in the gate dialog.
- The final evaluation totals saved points. Grades are A+ at 7,000+, A at 5,500+, B+ at 4,000+, otherwise B.

## 1. Word Puzzle

**Goal:** Reveal every cell in a crossword-style board by finding the route's required words.

| Route | Letters | Required words |
|---|---|---|
| Sort & Consolidate Packages | STREAM | STREAM, MASTER, SMART, TERMS, TEAM, RATE |
| Dispatch Stork Carrier | LOADER | ORDEAL, LOADER, OLDER, ROAD, LOAD, DEAL |
| Kickstart Sustainable Delivery | DELIVER | DELIVER, DRIVE, LIVER, LIVED, VEIL, RIDE |

- Select letters by tapping or swiping around the letter wheel; Enter submits. Clear resets the current selection and Shuffle changes letter positions.
- Each newly found required word reveals its cells and scores 10 points per letter. Extra words in the route's bonus list score 15 points each.
- Three hints are available per route. A hint reveals one unrevealed board cell and deducts 15 points (not below zero).
- The clock is displayed but does not affect the score. The route ends when every board cell is revealed.
- The completion formula is intended to add a route bonus (150/180/200 points), then clamp the result to 250–450/480/500 by route.

**Resolved:** Completion scoring uses wpRi cleanly, awarding the route bonus and clamping correctly to 250-450/480/500 per difficulty. All words in the LOADER route (including ORDEAL) are fully valid and spellable from the letter wheel.

## 2. Baby Delivery Maze

**Goal:** Navigate from the factory start to the nursery exit through a wall maze. Movement is by arrow buttons, keyboard arrows/WASD, or touch swipe.

| Route | Size | Parcels | Move par |
|---|---:|---:|---:|
| Canyon Route 1 (Easy) | 9×9 | 3 | 18 |
| Broken Bridge (Medium) | 11×11 | 3 | 28 |
| Storm Pass & Wolves (Hard) | 13×13 | 4 | 40 |

- Walls block movement. Every valid movement into an open cell counts as one move; blocked moves do not count.
- Parcels are optional collectibles. Reaching the exit completes the level whether or not all parcels were collected.
- The timer starts on the first valid move.
- Score starts at 280/320/360 by difficulty, adds 35 per collected parcel, adds a time bonus of up to 150 (reduced by 2 per second), and subtracts 3 per move above par. Final score is floored at 250 and capped at 450/480/500.

## 3. Fix the Broken Delivery

**Goal:** First arrange the logistics steps in the displayed correct order, then choose the best response to each operational fault.

| Scenario | Ordered process steps | Faults |
|---|---:|---:|
| Baby Basket Order #101 (Easy) | 5 | 2 |
| Mountain Highway & Wolf Roadblock (Medium) | 6 | 3 |
| Severe Weather & Route Recalibration (Hard) | 7 | 4 |

- The process steps are shuffled. Correct picks are removed and added to an ordered list. Incorrect picks remain available and increment the wrong-pick count.
- Once all steps are ordered, the process portion starts with `max(40, 100 − 20 × wrong picks)` points.
- For each fault, select one of three corrective actions. The correct choice awards 40 points if correct on the first try, 20 after one wrong try, and 0 after two or more wrong tries. Incorrect choices are disabled; there is no attempt limit.
- A timer runs from scenario start. Completion adds up to 120 points for speed (120 minus elapsed seconds, minimum zero).
- Final score is floored at 250 and capped at 450/480/500. There is no timeout loss condition.

## 4. Detective Investigation

**Goal:** Use delivery clues to identify the culprit, location, and cause.

| Case | Investigation |
|---|---|
| The Late Baby Basket | Identify the hold order that delayed loading |
| The Swapped Stork Bundle | Identify the sorter responsible for a routing error |
| The Sabotaged Dispatch Coordinates | Identify who overwrote the flight coordinates |

- Players can open clues and toggle suspect buttons to cross suspects off. The toggles are visual aids; the answer is selected separately using culprit, location, and cause dropdowns.
- A correct accusation solves the case. There are two total accusation attempts.
- The first incorrect accusation costs 40 points. The second closes the case and records a score of 120.
- Correct-case score is `250 + max(0, 200 − elapsed seconds) − 40 × wrong accusations`, with a 250 floor and case cap of 450/480/500.
- The case timer begins when the case starts. No separate time-out failure is implemented.

## 5. Flip n Match

**Goal:** Find all matching character-card pairs by flipping two cards at a time.

| Difficulty | Cards | Pairs | Par time | Target tries |
|---|---:|---:|---:|---:|
| Warmup (Easy) | 8 | 4 | 25 sec | 6 |
| Standard (Medium) | 12 | 6 | 40 sec | 10 |
| Master (Hard) | 16 | 8 | 55 sec | 14 |

- A try is counted each time a second card is flipped.
- Matched pairs remain face-up. A mismatch is shown briefly, then both cards flip back.
- The game ends when all pairs are matched; there is no time limit.
- Score starts at 340/380/420 by difficulty, adds up to 150 for speed (`max(0, 50 − seconds) × 3`), subtracts 10 per try above target, and is clamped to 250–450/480/500.

## 6. Spot & Fix the Errors

**Goal:** Inspect the logistics scene image, tap the operational defect, and choose the correct standard operating procedure (SOP) fix. Each difficulty level now features its own dedicated logistics scene:

| Difficulty | Scene Image | Focus Area | Required fixes | Time limit |
|---|---|---|---:|---:|
| Depot Warehouse Floor (Easy) | ssets/spot_depot.jpg | Packaging, stacking, and pallet handling | 3 | 150 sec |
| Conveyor Chute & Sorter (Medium) | ssets/spot_conveyor.jpg | Automated sorting lines, chutes, and conveyor motors | 4 | 120 sec |
| Flight Deck Launchpad (Hard) | ssets/spot_flightdeck.jpg | Stork aerial dispatch, runway hazards, and storm warnings | 5 | 90 sec |

- **Depot Floor (Easy) Deficiencies:**
  1. Fragile wooden crate placed upside-down under heavy boxes.
  2. Damaged/torn unreadable optical barcode label on a shipping parcel.
  3. Unlatched cargo door with delivery bundle slipping out.
- **Conveyor Chute (Medium) Deficiencies:**
  1. Missing chute safety guardrail with parcel tipping off.
  2. Cargo transport hatch unlatched and bundle slipping.
  3. Conveyor junction bottleneck jam with 3 packages wedged.
  4. Overheated conveyor drive motor with smoke and alarm strobe.
- **Flight Deck (Hard) Deficiencies:**
  1. Cargo transport hatch unlatched and bundle slipping.
  2. Slippery hydraulic fluid / oil slick puddle on the stork takeoff runway.
  3. Conveyor junction bottleneck parcel jam.
  4. Dispatch weather terminal flashing an unattended lightning storm warning.
  5. Departing delivery stork missing required high-altitude flight goggles and pilot cap.
- Tapping a valid defect adds 100 points and opens three fix choices. A correct fix adds 40 points if the first choice is correct, or 20 after one or more incorrect choices.
- An incorrect tap costs 20 points. An incorrect fix choice costs 10 points and is disabled.
- The player must complete the difficulty's required number of fixes to finish early. On timeout, the level still records a score, even if fewer than the required fixes were completed.
- A speed bonus of up to 100 is awarded only if all required fixes are completed. Final score is floored at 200 and capped at 450/480/500.

**Display mismatch:** The HTML's initial counter and image alt text say “5 errors,” but the game logic changes the required count to 3, 4, or 5 according to difficulty.

## 7. Final Delivery (seminar bonus)

**Goal:** Unlock and answer the final handoff quiz.

- Enter the current seminar code. The default code in the page is `STORKS2026`; the control system can replace it. `DEMO` is also accepted.
- The quiz has two multiple-choice questions: one on last-mile delivery efficiency, and one on how Junior and Tulip resolved roadblocks.
- Wrong choices are disabled but do not consume a limited number of attempts. Correct answers advance immediately.
- Completing both questions awards a fixed 500 points. The displayed timer does not affect scoring.

## Review notes

- **Next Stop Skip Exploit:** Resolved. Next Stop is locked until the puzzle is cleared; skipping unfinished stops for 250 points is removed.
- **Star Rating Caps:** Aligned. Map caps match each difficulty level's true maximum (450 for Easy, 480 for Medium, 500 for Hard) so 3-star thresholds are accurate.
- **Word Puzzle Completion:** Resolved. Uses wpRi cleanly without reference errors.
- **Spot & Fix Multi-Scene Inspection:** Resolved. Easy, Medium, and Hard now load their own dedicated logistics scene images with matching problem counts.
- **Offline Resilience:** Added automatic queuing and retry for Firebase cloud score sync.
- **Mobile Haptics:** Added subtle native vibrations for picks, matches, wins, and error shakes.
