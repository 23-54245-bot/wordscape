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

- Each completed game stop records points and awards 1–3 stars based on its difficulty cap: 3 stars at 85% or higher, 2 at 60% or higher, otherwise 1. The caps are 450 (Easy), 480 (Medium), and 500 (Hard).
- Game scores share a 250-point completion baseline, a game-specific accuracy bonus (up to 150/180/200 by difficulty), and any applicable 50-point no-help bonus, clamped to the stop's cap. The final quiz awards 500 points. Results show the score and star rating separately.
- Replaying an already passed stop updates its saved result only when the new score is higher; the best result is retained.
- The Next Stop control is available only after the active stop has been completed.
- Gate authorization is separate from game completion and can be released by the host/control system.
- The final evaluation totals points from all 19 playable stops (maximum 9,080 points). Grade bands use the course maximum: A+ at 85%+, A at 70%+, B+ at 60%+, otherwise B.
- The certificate is available only after every game and bonus stop is complete, all host checkpoints are released, and the courier reaches the final evaluation. It shows the courier name, grade, points, stars, and completion date, and can be printed or saved as a PDF.

## 1. Word Puzzle

**Goal:** Reveal every cell in a crossword-style board by finding the route's required words.

| Route | Letters | Required words |
|---|---|---|
| Sort & Consolidate Packages | STREAM | STREAM, MASTER, SMART, TERMS, TEAM, RATE |
| Dispatch Stork Carrier | LOADER | ORDEAL, LOADER, OLDER, ROAD, LOAD, DEAL |
| Kickstart Sustainable Delivery | DELIVER | DELIVER, DRIVE, LIVER, LIVED, VEIL, RIDE |

- Select letters by tapping or swiping around the letter wheel; Enter submits. Clear resets the current selection and Shuffle changes letter positions.
- Each newly found required word reveals its cells. Extra words in the route's bonus list are accepted but do not affect the completion score.
- Three hints are available per route. A hint reveals one unrevealed board cell. Using any hint removes the no-help bonus.
- The clock is displayed but does not affect the score. The route ends when every board cell is revealed.
- Completion score is 250 points, plus an accuracy bonus of up to 150/180/200 based on the proportion of required words found without a prior incorrect submission, plus 50 points if no hints were used. The result is capped at 450/480/500 by route.

**Resolved:** Completion scoring uses wpRi cleanly and clamps to 250-450/480/500 per difficulty. All words in the LOADER route (including ORDEAL) are fully valid and spellable from the letter wheel.

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
- For each fault, select one of three corrective actions. Incorrect process and fault choices provide guidance and can be retried.
- A correct fault action is followed by its safety/operations rationale and a Continue control; completed rationales can be reviewed at the end.
- Completion awards 250 points, an accuracy bonus of up to 150/180/200 based on first-try process and fault choices, and a 50-point no-help bonus. The result is capped at 450/480/500. The timer does not affect score.

## 4. Detective Investigation

**Goal:** Use delivery clues to identify the culprit, location, and cause.

| Case | Investigation |
|---|---|
| The Late Baby Basket | Identify the hold order that delayed loading |
| The Swapped Stork Bundle | Identify the sorter responsible for a routing error |
| The Sabotaged Dispatch Coordinates | Identify who overwrote the flight coordinates |

- Players review and optionally pin six evidence records, then mark suspects cleared as a visual note. These notes do not change the answer.
- The accusation is made in three steps: culprit, location, and cause. Incorrect answers provide a clue-based nudge and can be retried; progressive hints are available for each step.
- Completing the case awards 250 points, an accuracy bonus of up to 150/180/200 based on first-try answers, and a 50-point no-help bonus if no direct-answer hint was used. The result is capped at 450/480/500.
- The case timer begins when the case starts and does not affect score. The final hint for a step reveals and selects its answer.

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
| Depot Warehouse Floor (Easy) | `assets/spot_depot.jpg` | Packaging, stacking, and pallet handling | 3 | 150 sec |
| Conveyor Chute & Sorter (Medium) | `assets/spot_conveyor.jpg` | Automated sorting lines, chutes, and conveyor motors | 4 | 120 sec |
| Flight Deck Launchpad (Hard) | `assets/spot_flightdeck.jpg` | Stork aerial dispatch, runway hazards, and storm warnings | 5 | 90 sec |

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
- Tapping a valid defect opens three fix choices. Correct fixes explain their safety rationale and are collected for review; incorrect choices prompt the player to reconsider the risk without revealing the answer.
- The player can finish early by completing the difficulty's required number of fixes. On timeout, the level still records a score, even if fewer than the required fixes were completed.
- Completion score is 250 points, plus an accuracy bonus of up to 150/180/200 based on first-try fixes, plus 50 points. The result is capped at 450/480/500 by difficulty; elapsed time and the number of fixes completed do not change the score.

## 7. Final Delivery (seminar bonus)

**Goal:** Unlock and answer the final handoff quiz.

- Enter the current seminar code published by the host through the control system. The code field remains unavailable until a code is published.
- The quiz has two multiple-choice questions: one on last-mile delivery efficiency, and one on how Junior and Tulip resolved roadblocks.
- Wrong choices are disabled but do not consume a limited number of attempts. A short lesson explains each correct answer before the player continues; lessons remain available to review on the result. Questions must be answered in order, and host code updates cannot restart an unlocked attempt.
- Completing both questions awards a fixed 500 points. The displayed timer does not affect scoring.
- The final certificate shows the host-published evaluation form link and QR code. Hosts can enter an HTTPS form URL in the Control Tower to generate a QR code automatically, or upload a PNG, JPG, or WebP QR image up to 256 KB; when both are set, the uploaded QR is shown alongside the clickable link.

## Review notes

- **Next Stop Skip Exploit:** Resolved. Next Stop is locked until the puzzle is cleared; skipping unfinished stops for 250 points is removed.
- **Star Rating Caps:** Aligned. Map caps match each difficulty level's maximum (450 for Easy, 480 for Medium, 500 for Hard) so 3-star thresholds are accurate.
- **Replay Scoring:** Resolved. Replays retain the player's best score and star result.
- **Word Puzzle Completion:** Resolved. Uses wpRi cleanly without reference errors.
- **Detective Investigation Board:** Redesigned with reviewable/pinnable evidence, suspect notes, and explicit Who/Where/Why progress. Removed the control that exposed the culprit answer directly.
- **Spot & Fix Inspection:** Easy, Medium, and Hard load their own scene images; the counter and image description reflect each level's required fix count.
- **Offline Resilience:** Added automatic queuing and retry for Firebase cloud score sync.
- **Completion and Persistence Safety:** Stops only the active game's timer on navigation while preserving its final elapsed time, rejects invalid stop launches and scores, ignores duplicate completion callbacks, clamps saved results to the stop cap, and sanitizes restored progress.
- **Mobile Haptics:** Added subtle native vibrations for picks, matches, wins, and error shakes.
