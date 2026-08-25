import '../stage/game_state.dart';
import '../stage/stage_definition.dart';

abstract class BonusObjective {
  final String id;
  final String title;
  final String description;

  const BonusObjective({
    required this.id,
    required this.title,
    required this.description,
  });

  /// Evaluates whether this bonus objective was achieved upon stage completion.
  bool isAchieved(GameState state, StageDefinition stage);
}
