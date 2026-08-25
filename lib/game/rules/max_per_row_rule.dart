import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_rule.dart';

class MaxPerRowRule extends StageRule {
  final int maxCount;

  const MaxPerRowRule({
    this.maxCount = 1,
    super.id = 'max_per_row',
    super.description = 'Each row can contain at most one critter',
    super.isBlocking = true,
  });

  @override
  RuleEvaluation evaluate(GameState state, StageDefinition stage) {
    final positions = state.placedCritterPositions;
    final Set<CellPosition> conflicts = {};
    String? firstMessage;

    for (int r = 0; r < stage.size; r++) {
      final inRow = positions.where((p) => p.row == r).toList();
      if (inRow.length > maxCount) {
        conflicts.addAll(inRow);
        firstMessage ??= 'Row ${r + 1} has more than $maxCount critter!';
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
