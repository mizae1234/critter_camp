import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';

class RuleEvaluation {
  final bool isValid;
  final bool isBlocking;
  final Set<CellPosition> conflictingCells;
  final String? violationMessage;

  const RuleEvaluation({
    required this.isValid,
    this.isBlocking = true,
    this.conflictingCells = const {},
    this.violationMessage,
  });

  static const RuleEvaluation valid = RuleEvaluation(
    isValid: true,
    conflictingCells: {},
  );
}

abstract class StageRule {
  final String id;
  final String description;
  final bool isBlocking;

  const StageRule({
    required this.id,
    required this.description,
    this.isBlocking = true,
  });

  /// Evaluates whether the current state adheres to this rule.
  RuleEvaluation evaluate(GameState state, StageDefinition stage);
}
