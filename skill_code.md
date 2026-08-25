# Critter Camp — System Architecture & Code Blueprint (`skill_code.md`)

> **Developer Handbook & Architecture Reference**  
> Documenting the complete directory structure, game engine logic, extensible rule & goal systems, 30-stage journey progression across 6 story chapters, anti-stuck mascot nudge system, universal localization, backend/database integration, smart monetization guardrails, and developer recipes for adding new content.

---

## 1. High-Level Architecture Overview

Critter Camp is architected around **6 decoupled core pillars**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          CRITTER CAMP APP                              │
├────────────────────────────────────────────────────────────────────────┤
│ 1. Core Puzzle Engine   │ Data-driven StageDefinition (Goals + Rules)  │
│                         │ Multi-solution validation without fixed keys │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 2. 30-Stage Progression │ 6 Chapters / Biomes with rich story lore     │
│                         │ Handcrafted, verified mathematical solvers   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 3. Anti-Stuck Nudge     │ MascotSpeechBubble (40s inactivity trigger)  │
│                         │ Progressive hint clues + glowing toolbar     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 4. Player Identity      │ Persistent Guest UUID ↔ Account Merge        │
│                         │ Zero progress loss on account connection     │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 5. Data & Sync Layer    │ Local-First SharedPreferences + Queue        │
│                         │ Safe Conflict Merge (MAX stars, MIN moves)   │
├─────────────────────────┼──────────────────────────────────────────────┤
│ 6. Smart Monetization   │ AdPolicyService (Cooldown, Interval, Gap)    │
│                         │ ProgressiveHintService (3-Tier Multi-Clues)  │
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
│   │   ├── app.dart                              # Root Router, Title Screen controller & DI container
│   │   └── theme/                                # Material 3 Design System & Theme Tokens
│   │       ├── app_colors.dart                   # Curated palette + 8 Habitat colors
│   │       ├── app_typography.dart               # Plus Jakarta Sans typography scale
│   │       ├── app_spacing.dart                  # Spacing constants & border radiuses
│   │       └── app_theme.dart                    # ThemeData configuration
│   │
│   ├── core/                                     # Shared Low-Level Components
│   │   ├── localization/
│   │   │   └── app_strings.dart                  # Complete English/Thai bilingual dictionary & reactive notifier
│   │   ├── storage/
│   │   │   └── local_storage.dart                # Local SharedPreferences & Pending Sync Queue
│   │   └── widgets/                              # Reusable Design System Widgets
│   │       ├── critter_button.dart               # Primary / Secondary / Ghost buttons
│   │       ├── critter_card.dart                 # Elevated and flat cozy cards
│   │       ├── critter_avatar.dart               # Character avatar with frame
│   │       ├── heart_indicator.dart              # 3-Heart lives indicator
│   │       ├── critter_bottom_nav.dart           # Floating 5-tab navigation bar
│   │       └── mascot_speech_bubble.dart         # Animated Mascot Speech Bubble for Anti-Stuck Nudges
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
│   │   │   ├── stage_definition.dart             # Problem Definition (Size, Board, Chapter, Story Lore)
│   │   │   ├── game_state.dart                   # Immutable grid state, moves, hints, elapsed time
│   │   │   └── stages/
│   │   │       └── stage_catalog.dart            # Complete 30-Stage Adventure Catalog (Stages 1 to 30)
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
│   │   │   └── stage_solver.dart                 # On-the-fly backtracking solver for hints & verification
│   │   ├── engine/
│   │   │   └── puzzle_controller.dart            # Board state controller, timer, inactivity tracker
│   │   └── widgets/
│   │       ├── puzzle_board_widget.dart          # Grid renderer with color zones & thick borders
│   │       ├── puzzle_cell_widget.dart           # Interactive cell tile
│   │       └── puzzle_toolbar_widget.dart        # Bottom tools (Place Critter, Mark X, Undo, Hint)
│   │
│   ├── services/                                 # Business & Platform Services
│   │   ├── api/
│   │   │   └── api_client.dart                   # HTTP client for Admin/Cloud API
│   │   ├── config/
│   │   │   └── app_config_service.dart           # Remote configuration service & cached storage
│   │   ├── ads/
│   │   │   ├── ads_service.dart                  # Google AdMob SDK wrapper
│   │   │   └── ad_policy_service.dart            # Frequency capping & guardrail engine
│   │   ├── hints/
│   │   │   └── progressive_hint_service.dart     # 3-Tier progressive clue generator
│   │   ├── analytics/
│   │   │   └── analytics_service.dart            # Telemetry tracking & duplicate reward prevention
│   │   ├── identity/
│   │   │   └── player_identity_service.dart      # Guest identity & account merge service
│   │   ├── sync/
│   │   │   └── cloud_sync_service.dart           # Local-first storage & async cloud sync engine
│   │   └── audio/
│   │       └── audio_service.dart                # Sound effects & volume controller
│   │
│   └── features/                                 # Presentation Layer (8 Full Screens + Dialogs)
│       ├── onboarding/
│       │   └── presentation/first_launch_screen.dart # Dynamic Title Screen with Continue button
│       ├── home/
│       │   └── presentation/home_screen.dart     # Home hub with full-bleed campfire banner
│       ├── journey/
│       │   └── presentation/journey_screen.dart  # 30-stage trail map with 6 chapter milestones
│       ├── gameplay/
│       │   ├── presentation/gameplay_screen.dart # Active puzzle board with story dialogue & speech bubble
│       │   └── dialogs/
│       │       ├── oops_dialog.dart              # Rule conflict explanation modal
│       │       └── stage_complete_dialog.dart    # Victory modal with star breakdown & double rewards
│       ├── collection/
│       │   ├── presentation/collection_screen.dart # Critter compendium
│       │   └── dialogs/critter_detail_modal.dart # Critter bio, favorite snack, and perk modal
│       ├── daily/
│       │   └── presentation/daily_challenge_screen.dart # Daily puzzle banner & 7-day streak calendar
│       ├── leaderboard/
│       │   └── presentation/leaderboard_screen.dart # Daily/Weekly/Global leaderboards
│       ├── tutorial/
│       │   └── presentation/tutorial_screen.dart # 3 Golden rules interactive guide
│       └── settings/
│           └── presentation/settings_screen.dart # Audio volume, language switch, cloud sync
│
├── tool/
│   └── stage_generator.dart                      # Automated mathematical solver & stage generator
├── assets/
│   ├── images/                                   # High-res art assets (bg_campsite, bg_gameplay, app_icon)
│   └── audio/                                    # Tactical audio SFX (pop.wav, victory.wav)
└── test/                                         # 42 Comprehensive Unit & Integration Tests
```

---

## 3. 30-Stage Adventure & 6 Story Chapters

The adventure is divided into **6 thematic Chapters / Biomes**, each featuring a character guide with dedicated story dialogues in English and Thai:

| Chapter | Biome Name | Stages | Board Size | Mascot Guide | Story Theme |
| :---: | :--- | :---: | :---: | :---: | :--- |
| **1** | 🏕️ **Whispering Meadow** | **1 – 5** | 4x4 $\rightarrow$ 5x5 | 🦊 **Hazel** | Setting up camp & gathering first supplies |
| **2** | 🌲 **Pine Haven Trail** | **6 – 10** | 5x5 $\rightarrow$ 6x6 | 🐿️ **Finn** | Exploring ancient pine trees & pinecone stashes |
| **3** | 🪻 **Lavender Valley** | **11 – 15** | 6x6 | 🦔 **Pip** | Harvesting wild herbs & brewing evening tea |
| **4** | 🌊 **Willow Brook** | **16 – 20** | 6x6 $\rightarrow$ 7x7 | 🦦 **River** | Hopping across stepping stones & waterfalls |
| **5** | 🍂 **Autumn Hollow** | **21 – 25** | 7x7 | 🦌 **Fawn** | Golden leaf trails & harvest pie feasts |
| **6** | 🌌 **Starry Summit** | **26 – 30** | 7x7 $\rightarrow$ 8x8 | 🦉 **Luna** | Starlit mountain peak, meteor showers & Aurora |

### Story Lore Representation in Code (`StageDefinition`):
```dart
class StageDefinition {
  final int stageNumber;
  final String name;
  final String biomeName;
  final int size;
  final int chapterNumber;
  final String chapterName;
  final String storySpeaker;
  final String speakerEmoji;
  final String storyTextEn;
  final String storyTextTh;
  final List<List<int>> habitatGrid;
  final List<BonusObjective> bonusObjectives;
  final String rewardCritterId;
  final int baseAcornsReward;
}
```

---

## 4. Anti-Stuck Mascot Speech Bubble System

To avoid player frustration without exerting time pressure, the game tracks player interaction timestamps in `PuzzleController`:

1. **Inactivity Detection**: If `_secondsSinceLastInteraction >= 35` seconds without a move, `shouldShowHintNudge` becomes `true`.
2. **Visual Presentation**: `MascotSpeechBubble` renders above the toolbar with the chapter mascot's emoji and a gentle message:
   - 🇹🇭: *"ติดตรงไหน ให้ผมช่วยใบ้ไหมครับ? 💡"*
   - 🇬🇧: *"Need a hand? Tap Hint for a friendly clue! 💡"*
3. **Auto-Dismiss**: Tapping any cell on the board, selecting a tool, undoing, or taking the hint resets the inactivity counter immediately.

---

## 5. Universal Localization Engine (`AppStrings`)

Localization uses a reactive `ValueNotifier<String> AppStrings.currentLocale`:
* Switching language (`AppStrings.currentLocale.value = 'th'` or `'en'`) immediately rebuilds the `MaterialApp` widget tree.
* Helper getters like `AppStrings.isThai` and `AppStrings.playCurrentStage` provide clean, zero-boilerplate string access across all 8 screens and modal dialogs.

---

## 6. How to Add a New Stage Recipe

To create a new handcrafted stage:
1. Define the $N \times N$ `habitatGrid` ensuring each region has ID $0 \dots N-1$.
2. Run `dart run tool/stage_generator.dart` or `StageSolver.findAllSolutions(stage)` in unit tests to mathematically verify that at least one valid solution exists.
3. Add the stage definition to `StageCatalog.allStages`.
4. Run `flutter test` to ensure all 42 automated tests pass.
