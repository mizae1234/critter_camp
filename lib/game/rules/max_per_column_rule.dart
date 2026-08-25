import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_rule.dart';

class MaxPerColumnRule extends StageRule {
  final int maxCount;

  const MaxPerColumnRule({
    this.maxCount = 1,
    super.id = 'max_per_column',
    super.description = 'Each column can contain at most one critter',
    super.isBlocking = true,
  });

  @override
  RuleEvaluation evaluate(GameState state, StageDefinition stage) {
    final positions = state.placedCritterPositions;
    final Set<CellPosition> conflicts = {};
    String? firstMessage;

    for (int c = 0; c < stage.size; c++) {
      final inCol = positions.where((p) => p.col == c).toList();
      if (inCol.length > maxCount) {
        conflicts.addAll(inCol);
        firstMessage ??= 'Column ${c + 1} has more than $maxCount critter!';
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
