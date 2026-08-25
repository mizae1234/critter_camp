import '../models/puzzle_cell_state.dart';
import '../models/habitat_region.dart';
import '../goals/stage_goal.dart';
import '../goals/place_all_critters_goal.dart';
import '../goals/habitat_coverage_goal.dart';
import '../rules/stage_rule.dart';
import '../rules/no_adjacent_critters_rule.dart';
import '../rules/max_per_row_rule.dart';
import '../rules/max_per_column_rule.dart';
import '../rules/max_per_habitat_rule.dart';
import '../bonus/bonus_objective.dart';
import '../bonus/no_hints_bonus.dart';

class StageDefinition {
  final String id;
  final int stageNumber;
  final String name;
  final String biomeName;
  final int size;
  final List<List<int>> habitatGrid;
  final List<List<CellContent>>? initialGrid;
  final List<StageGoal> goals;
  final List<StageRule> rules;
  final List<BonusObjective> bonusObjectives;
  final String rewardCritterId;
  final int baseAcornsReward;
  final String description;

  const StageDefinition({
    required this.id,
    required this.stageNumber,
    required this.name,
    required this.biomeName,
    required this.size,
    required this.habitatGrid,
    this.initialGrid,
    this.goals = const [
      PlaceAllCrittersGoal(),
      HabitatCoverageGoal(),
    ],
    this.rules = const [
      MaxPerRowRule(),
      MaxPerColumnRule(),
      MaxPerHabitatRule(),
      NoAdjacentCrittersRule(),
    ],
    this.bonusObjectives = const [
      NoHintsBonus(),
    ],
    this.rewardCritterId = 'hazel',
    this.baseAcornsReward = 15,
    this.description = 'Place one critter per habitat without touching neighbors',
  });

  /// Counts the total number of unique habitat regions in this stage.
  int get totalHabitatCount {
    final Set<int> unique = {};
    for (final row in habitatGrid) {
      for (final cell in row) {
        unique.add(cell);
      }
    }
    return unique.length;
  }

  /// Gets the visual habitat region at a specific grid position.
  HabitatRegion getHabitatAt(int row, int col) {
    if (row < 0 || row >= size || col < 0 || col >= size) {
      return HabitatRegion.byIndex(0);
    }
    final int regionId = habitatGrid[row][col];
    return HabitatRegion.byIndex(regionId);
  }

  /// Creates a clean initial board state for stage start or restart.
  List<List<CellContent>> createInitialGrid() {
    if (initialGrid != null) {
      return List.generate(
        size,
        (r) => List<CellContent>.from(initialGrid![r]),
      );
    }
    return List.generate(
      size,
      (_) => List<CellContent>.filled(size, CellContent.empty),
    );
  }
}
