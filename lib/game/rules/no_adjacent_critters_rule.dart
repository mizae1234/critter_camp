import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_rule.dart';

class NoAdjacentCrittersRule extends StageRule {
  const NoAdjacentCrittersRule({
    super.id = 'no_adjacent_critters',
    super.description = 'Critters need personal space and cannot touch in any of the 8 directions',
    super.isBlocking = true,
  });

  @override
  RuleEvaluation evaluate(GameState state, StageDefinition stage) {
    final positions = state.placedCritterPositions;
    final Set<CellPosition> conflicts = {};

    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final p1 = positions[i];
        final p2 = positions[j];

        final int rowDiff = (p1.row - p2.row).abs();
        final int colDiff = (p1.col - p2.col).abs();

        if (rowDiff <= 1 && colDiff <= 1) {
          conflicts.add(p1);
          conflicts.add(p2);
        }
      }
    }

    if (conflicts.isNotEmpty) {
      return RuleEvaluation(
        isValid: false,
        isBlocking: isBlocking,
        conflictingCells: conflicts,
        violationMessage: 'Critters are touching each other! Give them some cozy personal space.',
      );
    }

    return RuleEvaluation.valid;
  }
}
