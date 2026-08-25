import '../../game/stage/stage_definition.dart';
import '../../game/stage/game_state.dart';
import '../../game/models/puzzle_cell_state.dart';
import '../../game/solver/stage_solver.dart';
import '../config/app_config_service.dart';

enum HintTier {
  observation,
  constraint,
  guidance,
}

class HintClue {
  final HintTier tier;
  final String title;
  final String message;
  final bool isFree;
  final int? suggestedRow;
  final int? suggestedCol;

  const HintClue({
    required this.tier,
    required this.title,
    required this.message,
    required this.isFree,
    this.suggestedRow,
    this.suggestedCol,
  });
}

class ProgressiveHintService {
  final AppConfigService configService;

  ProgressiveHintService({required this.configService});

  /// Evaluates current puzzle state and returns a progressive multi-solution friendly clue.
  HintClue generateClue({
    required StageDefinition stage,
    required GameState state,
    required int hintsUsedOnStage,
  }) {
    final mon = configService.monetization;
    final bool isFree = mon.firstHintFree && hintsUsedOnStage == 0;

    // 1. Tier 1 (First Hint): Observation Clue (General Region Focus)
    if (hintsUsedOnStage == 0) {
      // Find an unfilled habitat region
      final placedHabitats = <int>{};
      for (int r = 0; r < stage.size; r++) {
        for (int c = 0; c < stage.size; c++) {
          if (state.grid[r][c] == CellContent.critter) {
            placedHabitats.add(stage.getHabitatAt(r, c).id);
          }
        }
      }

      for (int r = 0; r < stage.size; r++) {
        for (int c = 0; c < stage.size; c++) {
          final habitat = stage.getHabitatAt(r, c);
          if (!placedHabitats.contains(habitat.id)) {
            return HintClue(
              tier: HintTier.observation,
              title: 'Camp Habitat Observation',
              message: 'Take a close look at the "${habitat.name}" region. Every designated habitat needs its own resident camper!',
              isFree: isFree,
            );
          }
        }
      }

      return HintClue(
        tier: HintTier.observation,
        title: 'Trail Focus',
        message: 'Observe the row and column distribution carefully. Look for rows that have the fewest open spaces.',
        isFree: isFree,
      );
    }

    // 2. Tier 2 (Second Hint): Constraint Deduction Clue (Diagonal / Neighbor Rules)
    if (hintsUsedOnStage == 1) {
      return HintClue(
        tier: HintTier.constraint,
        title: 'Camper Spacing Rule',
        message: 'Remember that critters cherish personal space — they cannot touch each other in any of the 8 directions, including diagonally!',
        isFree: isFree,
      );
    }

    // 3. Tier 3 (Third+ Hint): Dynamic Placement Helper (On-The-Fly Calculation)
    final sol = StageSolver.findSolution(stage, fromState: state);
    if (sol != null && sol.isNotEmpty) {
      final unplaced = sol.where((p) => state.grid[p.row][p.col] != CellContent.critter).toList();
      if (unplaced.isNotEmpty) {
        final p = unplaced.first;
        final habitat = stage.getHabitatAt(p.row, p.col);
        return HintClue(
          tier: HintTier.guidance,
          title: 'Pathfinder Guidance',
          message: 'A friendly camper would feel right at home in the ${habitat.name} zone around Row ${p.row + 1}, Column ${p.col + 1}!',
          isFree: isFree,
          suggestedRow: p.row,
          suggestedCol: p.col,
        );
      }
    }

    return HintClue(
      tier: HintTier.guidance,
      title: 'Camp Master Advice',
      message: 'Try clearing conflicting critters and placing in the most constrained habitat first.',
      isFree: isFree,
    );
  }
}
