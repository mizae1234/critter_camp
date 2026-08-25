import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'bonus_objective.dart';

class NoHintsBonus extends BonusObjective {
  const NoHintsBonus({
    super.id = 'no_hints_bonus',
    super.title = 'Intuitive Camper',
    super.description = 'Solve the puzzle without using hints',
  });

  @override
  bool isAchieved(GameState state, StageDefinition stage) {
    return state.hintsUsed == 0;
  }
}
