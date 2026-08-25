import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import 'stage_goal.dart';

class HabitatCoverageGoal extends StageGoal {
  const HabitatCoverageGoal({
    super.id = 'habitat_coverage',
    super.description = 'Ensure every habitat region has a resident critter',
  });

  @override
  bool isCompleted(GameState state, StageDefinition stage) {
    final positions = state.placedCritterPositions;
    final Set<int> representedHabitats = {};

    for (final pos in positions) {
      if (pos.row < stage.size && pos.col < stage.size) {
        representedHabitats.add(stage.habitatGrid[pos.row][pos.col]);
      }
    }

    final int totalHabitats = stage.totalHabitatCount;
    return representedHabitats.length == totalHabitats;
  }
}
