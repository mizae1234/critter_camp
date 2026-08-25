# Critter Camp — System Architecture & Code Blueprint (`skill_code.md`)

> **Developer Handbook & Architecture Reference**  
> Documenting the complete directory structure, game engine logic, extensible rule & goal systems, journey progression, backend/database integration, smart monetization guardrails, and developer recipes for adding new content.

---

## 1. High-Level Architecture Overview

Critter Camp is architected around **5 decoupled core pillars**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          CRITTER CAMP APP                              │
├────────────────────────────────────────────────────────────────────────┤
│ 1. Core Puzzle Engine   │ Data-driven StageDefinition (Goals + Rules)  │
│                         │ Multi-solution validation without fixed keys │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 2. Player Identity      │ Persistent Guest UUID ↔ Account Merge        │
│                         │ Zero progress loss on account connection     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 3. Data & Sync Layer    │ Local-First SharedPreferences + Queue        │
│                         │ Safe Conflict Merge (MAX stars, MIN moves)   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 4. Smart Monetization   │ AdPolicyService (Cooldown, Interval, Gap)    │
│                         │ ProgressiveHintService (3-Tier Multi-Clues)  │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 5. Shared Backend/Admin │ web/myapp/critter-camp (REST API + SQLite)   │
│                         │ Web Admin managed Ads & Remote Config        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Complete Project Directory Structure

```text
critter_camp/
├── lib/
│   ├── main.dart                                 # Flutter entry point (Initializes storage & launches CritterCampApp)
│   │
│   ├── app/                                      # Top-level App Configuration
│   │   ├── app.dart                              # Root Router & Dependency Injection container
│   │   └── theme/                                # Material 3 Design System & Theme Tokens
│   │       ├── app_colors.dart                   # Curated palette + 8 Habitat colors
│   │       ├── app_typography.dart               # Plus Jakarta Sans typography scale
│   │       ├── app_spacing.dart                  # Spacing constants & border radiuses
│   │       └── app_theme.dart                    # ThemeData configuration
│   │
│   ├── core/                                     # Shared Low-Level Components
│   │   ├── storage/
│   │   │   └── local_storage.dart                # Local SharedPreferences & Pending Sync Queue
│   │   └── widgets/                              # Reusable Design System Widgets
│   │       ├── critter_button.dart               # Primary / Secondary / Ghost buttons
│   │       ├── critter_card.dart                 # Elevated and flat cozy cards
│   │       ├── critter_avatar.dart               # Character avatar with frame
│   │       ├── heart_indicator.dart              # 3-Heart lives indicator
│   │       └── critter_bottom_nav.dart           # Floating 5-tab navigation bar
│   │
│   ├── data/                                     # Data Layer & Domain Models
│   │   ├── models/
│   │   │   ├── critter_model.dart                # Collectible Critter domain model
│   │   │   ├── player_profile.dart               # Camper profile & achievements
│   │   │   ├── user_progress.dart                # Progression snapshot model
│   │   │   └── leaderboard_entry.dart            # Leaderboard ranking entry
│   │   └── repositories/
│   │       ├── auth_repository.dart              # Player profile & authentication repository
│   │       ├── collection_repository.dart        # Critter collection unlock repository
│   │       ├── progress_repository.dart          # Local level progression repository
│   │       └── leaderboard_repository.dart       # Weekly/Camp leaderboard repository
│   │
│   ├── game/                                     # Core Puzzle Gameplay Engine
│   │   ├── models/
│   │   │   ├── puzzle_cell_state.dart            # CellContent (empty, critter, xMark) & CellPosition
│   │   │   ├── habitat_region.dart               # HabitatRegion definition & colorblind labels (A..H)
│   │   │   └── puzzle_move.dart                  # Move history item for Undo support
│   │   ├── stage/
│   │   │   ├── stage_definition.dart             # Pure Problem Definition (Size, Board, Goals, Rules)
│   │   │   ├── game_state.dart                   # Immutable grid state, moves, hints, elapsed time
│   │   │   └── stages/
│   │   │       └── stage_catalog.dart            # Catalog of handcrafted stages (Stage 1 to 5+)
│   │   ├── goals/                                # Extensible Goals System
│   │   │   ├── stage_goal.dart                   # Base abstract StageGoal interface
│   │   │   ├── place_all_critters_goal.dart      # Place N critters goal
│   │   │   └── habitat_coverage_goal.dart        # Every habitat region filled goal
│   │   ├── rules/                                # Extensible Rules & Constraints System
│   │   │   ├── stage_rule.dart                   # Base abstract StageRule interface & RuleEvaluation
│   │   │   ├── no_adjacent_critters_rule.dart    # 8-Neighbor touching constraint (H, V, Diagonal)
│   │   │   ├── max_per_row_rule.dart             # Maximum 1 critter per row
│   │   │   ├── max_per_column_rule.dart          # Maximum 1 critter per column
│   │   │   └── max_per_habitat_rule.dart         # Maximum 1 critter per habitat
│   │   ├── bonus/                                # Bonus Objectives (Stars 2 & 3)
│   │   │   ├── bonus_objective.dart              # Base abstract BonusObjective interface
│   │   │   ├── no_hints_bonus.dart               # Zero hints used bonus
│   │   │   └── move_efficiency_bonus.dart        # Move efficiency bonus (under N moves)
│   │   ├── validator/                            # Universal Puzzle Validator
│   │   │   ├── universal_stage_validator.dart    # Goals + Rules = Pass/Fail Engine
│   │   │   └── stage_validation_result.dart      # Pass status, conflict cells, and stars calculation
│   │   ├── solver/
│   │   │   └── stage_solver.dart                 # On-the-fly backtracking solver for hints
│   │   ├── engine/
│   │   │   └── puzzle_controller.dart            # Gameplay state manager, lives, undo, timer
│   │   └── widgets/
│   │       ├── puzzle_board_widget.dart          # Dynamic grid rendering with habitat borders
│   │       ├── puzzle_cell_widget.dart           # Single cell with animated critter / X / conflict
│   │       └── puzzle_toolbar_widget.dart        # Tool toggles (Critter/X), Undo, Pattern, Hint
│   │
│   ├── services/                                 # Platform & Infrastructure Services
│   │   ├── api/
│   │   │   └── api_client.dart                   # HTTP REST Client with offline fallback tolerance
│   │   ├── config/
│   │   │   └── app_config_service.dart           # Remote Ads & Monetization Config from Web Admin
│   │   ├── ads/
│   │   │   ├── ads_service.dart                  # Centralized Banner, Interstitial, and Rewarded Ads
│   │   │   └── ad_policy_service.dart            # Interstitial frequency guardrails & grace periods
│   │   ├── hints/
│   │   │   └── progressive_hint_service.dart     # 3-Tier Multi-Solution Progressive Hint Engine
│   │   ├── analytics/
│   │   │   └── analytics_service.dart            # Telemetry tracker & Reward grant deduplication
│   │   ├── identity/
│   │   │   └── player_identity_service.dart      # Guest UUID ↔ Authenticated Account merge
│   │   └── sync/
│   │       └── cloud_sync_service.dart           # Local-first save + Asynchronous cloud sync
│   │
│   └── features/                                 # UI Screens (16 Screens Prototype)
│       ├── onboarding/                           # First Launch & Welcome flow
│       ├── home/                                 # Camp Hub & Continue Playing
│       ├── journey/                              # Journey Map with Biomes & Stages
│       ├── gameplay/                             # Active Puzzle & Level Complete result
│       ├── collection/                           # Unlocked Critters showcase
│       ├── daily/                                # Daily Challenge grove
│       ├── tutorial/                             # Interactive rule guide
│       ├── leaderboard/                          # Camper rankings
│       ├── profile/                              # Camper Profile & Account Connect
│       └── settings/                             # Audio, Accessibility & Cloud Sync status
│
├── web/myapp/critter-camp/                       # Shared Platform Backend & Database
│   ├── server.js                                 # Zero-dependency Node.js REST API Server (:8097)
│   ├── package.json                              # Scripts & metadata
│   ├── database/
│   │   ├── schema.sql                            # Production SQL Schema (players, progress, config)
│   │   ├── db.js                                 # Database controller with safe conflict merge
│   │   └── seed_admob.js                         # Google AdMob Test & Production Seeder
│   └── routes/
│       ├── config_routes.js                      # GET/POST /api/v1/config/critter-camp
│       ├── player_routes.js                      # POST /api/v1/players/identity & /upgrade
│       └── sync_routes.js                        # GET/POST /api/v1/sync/progress
│
└── test/                                         # Comprehensive Automated Unit Tests (37 Tests)
    ├── universal_stage_validator_test.dart       # Multi-solution pass verification
    ├── stage_lifecycle_test.dart                 # Reset, controller, and solver tests
    ├── puzzle_controller_test.dart               # Board moves and tool selection tests
    ├── puzzle_validator_test.dart                # Legacy rule validation compatibility
    ├── player_identity_service_test.dart         # Guest UUID & Lossless upgrade tests
    ├── cloud_sync_service_test.dart              # Local-first & Safe conflict merge tests
    ├── app_config_service_test.dart              # Remote config caching & Ads tests
    ├── ad_policy_service_test.dart               # Interstitial cooldown & grace period tests
    ├── progressive_hint_service_test.dart        # 3-Tier multi-clue hints tests
    └── analytics_service_test.dart               # Telemetry tracking & deduplication tests
```

---

## 3. Core Puzzle Game Engine Logic

### 3.1 The Multi-Solution Philosophy

> **Stage = Problem Definition (Board + Goals + Rules)**  
> ❌ **NO `expectedSolution` or hardcoded placement matrices are stored in `StageDefinition`.**

Validation is a pure mathematical function:

$$\text{Validation Result} = (\text{All Goals Achieved}) \land (\text{Zero Blocking Rule Violations})$$

### 3.2 Goals System (`lib/game/goals/`)

Every goal implements [`StageGoal`](file:///Users/kanittamac/web/critter_camp/lib/game/goals/stage_goal.dart):
```dart
abstract class StageGoal {
  String get id;
  String get title;
  String get description;
  bool isAchieved(GameState state, StageDefinition stage);
}
```

* **`PlaceAllCrittersGoal(requiredCritters)`**: Checks `state.critterCount == requiredCritters`.
* **`HabitatCoverageGoal()`**: Checks that every unique `HabitatRegion` in `stage.habitatGrid` contains at least one critter.

### 3.3 Rules System (`lib/game/rules/`)

Every rule implements [`StageRule`](file:///Users/kanittamac/web/critter_camp/lib/game/rules/stage_rule.dart):
```dart
abstract class StageRule {
  String get id;
  String get name;
  String get violationMessage;
  RuleEvaluation evaluate(GameState state, StageDefinition stage);
}
```

* **`NoAdjacentCrittersRule()`**: Evaluates 8-neighbor adjacency:
  $$|r_1 - r_2| \le 1 \land |c_1 - c_2| \le 1 \implies \text{Conflict}$$
* **`MaxPerRowRule(maxCritters: 1)`**: Prevents $>1$ critter per row.
* **`MaxPerColumnRule(maxCritters: 1)`**: Prevents $>1$ critter per column.
* **`MaxPerHabitatRule(maxCritters: 1)`**: Prevents $>1$ critter in the same habitat region.

### 3.4 Dynamic Solver (`StageSolver`)

[`StageSolver`](file:///Users/kanittamac/web/critter_camp/lib/game/solver/stage_solver.dart) uses recursive constraint-satisfaction backtracking with forward pruning to:
1. Verify if any handcrafted stage is mathematically solvable.
2. Find all valid solutions for a stage (`findAllSolutions()`).
3. Calculate real-time valid moves for the **Hint Engine** from current board state without stored answers.

---

## 4. How to Add a New Stage (Step-by-Step Recipe)

To create a new stage (e.g. Stage 6: *Emerald Canopy*), open [`lib/game/stage/stages/stage_catalog.dart`](file:///Users/kanittamac/web/critter_camp/lib/game/stage/stages/stage_catalog.dart) and define:

```dart
static final StageDefinition stage6 = StageDefinition(
  stageNumber: 6,
  name: 'Emerald Canopy',
  biomeName: 'Ancient Hollow',
  description: 'Place 6 critters into 6 habitat canopies without touching.',
  size: 6,
  requiredCritters: 6,
  baseAcornsReward: 25,
  rewardCritterId: 'moss',
  habitatGrid: [
    [0, 0, 1, 1, 2, 2],
    [0, 0, 1, 1, 2, 2],
    [3, 3, 1, 1, 4, 4],
    [3, 3, 5, 5, 4, 4],
    [3, 3, 5, 5, 4, 4],
    [5, 5, 5, 5, 4, 4],
  ],
  goals: const [
    PlaceAllCrittersGoal(requiredCritters: 6),
    HabitatCoverageGoal(),
  ],
  rules: const [
    NoAdjacentCrittersRule(),
    MaxPerRowRule(),
    MaxPerColumnRule(),
    MaxPerHabitatRule(),
  ],
  bonusObjectives: const [
    NoHintsBonus(),
    MoveEfficiencyBonus(maxMoves: 12),
  ],
);
```

Then register `stage6` inside `StageCatalog.allStages`:
```dart
static List<StageDefinition> get allStages => [stage1, stage2, stage3, stage4, stage5, stage6];
```

---

## 5. How to Create a New Custom Rule

To create a custom rule (e.g. `MustTouchBorderRule`):

1. Create `lib/game/rules/must_touch_border_rule.dart`:
```dart
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import '../models/puzzle_cell_state.dart';
import 'stage_rule.dart';

class MustTouchBorderRule extends StageRule {
  const MustTouchBorderRule({
    super.id = 'must_touch_border',
    super.name = 'Border Campers',
    super.violationMessage = 'Critters must stay near the border of the forest!',
  });

  @override
  RuleEvaluation evaluate(GameState state, StageDefinition stage) {
    final Set<CellPosition> conflicts = {};
    for (final pos in state.placedCritterPositions) {
      final bool onBorder = pos.row == 0 || pos.row == stage.size - 1 || pos.col == 0 || pos.col == stage.size - 1;
      if (!onBorder) {
        conflicts.add(pos);
      }
    }
    return RuleEvaluation(hasViolation: conflicts.isNotEmpty, conflictingCells: conflicts);
  }
}
```
2. Attach it to any `StageDefinition.rules` list!

---

## 6. Smart Monetization & Ad Guardrails Architecture

### 6.1 Interstitial Guardrails (`AdPolicyService`)

```text
               Stage Completed
                     │
                     ▼
          AdPolicyService.canShowInterstitial()
                     │
    ┌────────────────┴────────────────┐
    ▼                                 ▼
[ BLOCKED ]                       [ ALLOWED ]
• Stage < 4 (Early protection)    • Stage >= 4
• Interval not reached            • Interval reached (e.g. Every 3 stages)
• Cooldown < 180s                 • Cooldown >= 180s
• Rewarded Grace Period < 90s     • Rewarded Grace Period >= 90s
```

### 6.2 Progressive Hint Engine (`ProgressiveHintService`)

| Hint Tier | Type | Behavior | Cost |
|:---|:---|:---|:---|
| **Tier 1** | **Observation** | Identifies unfulfilled habitat zone or constrained row | **FREE** (First hint) |
| **Tier 2** | **Constraint Deduction** | Reminds player of 8-neighbor diagonal rules | **Rewarded Ad** |
| **Tier 3** | **Dynamic Guidance** | Uses `StageSolver` on-the-fly to calculate a safe placement | **Rewarded Ad** |

---

## 7. Player Identity, Database & Cloud Sync

### 7.1 Play-First Identity Flow

```text
Fresh Install → Persistent Guest UUID (LocalStorage) → Play Immediately
                                                            │
                                  Later: Connect Account (Email/Google/Apple)
                                                            │
                                                            ▼
                                        Lossless Account Upgrade Merge
                                        (All Stages, Stars & Acorns Preserved)
```

### 7.2 Safe Conflict Merge Rules

When synchronizing local and cloud progress:
* $\text{completed} = \text{local.completed} \lor \text{cloud.completed}$
* $\text{stars} = \max(\text{local.stars}, \text{cloud.stars})$
* $\text{bestMoves} = \min(\text{validLocal.bestMoves}, \text{validCloud.bestMoves})$
* $\text{totalAcorns} = \max(\text{local.acorns}, \text{cloud.acorns})$

---

## 8. Automated Testing & Verification Commands

```bash
# 1. Run full Flutter unit test suite (37 tests)
flutter test

# 2. Run Dart static analyzer (0 warnings target)
flutter analyze

# 3. Build Web release bundle
flutter build web --release

# 4. Start local Backend Server
node web/myapp/critter-camp/server.js

# 5. Run AdMob seed & verify test script
node web/myapp/critter-camp/test_admob_config.js
```
