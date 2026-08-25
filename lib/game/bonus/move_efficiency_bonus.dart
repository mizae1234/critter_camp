import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'bonus_objective.dart';

class MoveEfficiencyBonus extends BonusObjective {
  final int maxMoves;

  const MoveEfficiencyBonus({
    required this.maxMoves,
    super.id = 'move_efficiency_bonus',
    super.title = 'Pathfinder Precision',
    super.description = 'Solve the puzzle efficiently with minimal moves',
  });

  @override
  bool isAchieved(GameState state, StageDefinition stage) {
    return state.movesCount <= maxMoves;
  }
}
