import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_rule.dart';

class MaxPerHabitatRule extends StageRule {
  final int maxCount;

  const MaxPerHabitatRule({
    this.maxCount = 1,
    super.id = 'max_per_habitat',
    super.description = 'Each habitat region can contain at most one critter',
    super.isBlocking = true,
  });

  @override
  RuleEvaluation evaluate(GameState state, StageDefinition stage) {
    final positions = state.placedCritterPositions;
    final Map<int, List<CellPosition>> habitatMap = {};

    for (final p in positions) {
      if (p.row < stage.size && p.col < stage.size) {
        final int regionId = stage.habitatGrid[p.row][p.col];
        habitatMap.putIfAbsent(regionId, () => []).add(p);
      }
    }

    final Set<CellPosition> conflicts = {};
    String? firstMessage;

    for (final entry in habitatMap.entries) {
      if (entry.value.length > maxCount) {
        conflicts.addAll(entry.value);
        firstMessage ??= 'Habitat region has more than $maxCount critter!';
      }
    }

    if (conflicts.isNotEmpty) {
      return RuleEvaluation(
        isValid: false,
        isBlocking: isBlocking,
        conflictingCells: conflicts,
        violationMessage: firstMessage,
      );
    }

    return RuleEvaluation.valid;
  }
}
