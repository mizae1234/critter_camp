import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_goal.dart';

class PlaceAllCrittersGoal extends StageGoal {
  final int? requiredCount;

  const PlaceAllCrittersGoal({
    this.requiredCount,
    super.id = 'place_all_critters',
    super.description = 'Find a cozy camp spot for all required critters',
  });

  @override
  bool isCompleted(GameState state, StageDefinition stage) {
    final target = requiredCount ?? stage.size;
    return state.critterCount == target;
  }
}
