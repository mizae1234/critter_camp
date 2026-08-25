import '../stage/game_state.dart';
import '../stage/stage_definition.dart';

abstract class StageGoal {
  final String id;
  final String description;

  const StageGoal({
    required this.id,
    required this.description,
  });

  /// Evaluates whether this goal is satisfied by the current game state.
  bool isCompleted(GameState state, StageDefinition stage);
}
