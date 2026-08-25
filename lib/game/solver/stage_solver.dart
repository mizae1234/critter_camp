import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import '../validator/universal_stage_validator.dart';

class StageSolver {
  /// Finds ALL valid solutions for a given stage definition without relying on pre-stored answers.
  static List<List<CellPosition>> findAllSolutions(StageDefinition stage) {
    final List<List<CellPosition>> solutions = [];
    final List<CellPosition> currentPlacement = [];
    _backtrack(stage, 0, currentPlacement, solutions);
    return solutions;
  }

  /// Finds ANY one valid solution starting from the current board state.
  static List<CellPosition>? findSolution(StageDefinition stage, {GameState? fromState}) {
    final List<List<CellPosition>> solutions = [];
    final List<CellPosition> currentPlacement = fromState?.placedCritterPositions ?? [];
    
    // Check if starting placement already violates rules
    if (fromState != null) {
      final initialEval = UniversalStageValidator.validate(state: fromState, stage: stage);
      if (initialEval.hasRuleViolations) {
        return null;
      }
    }

    _backtrack(stage, currentPlacement.length, currentPlacement, solutions, maxSolutions: 1);
    return solutions.isNotEmpty ? solutions.first : null;
  }

  static void _backtrack(
    StageDefinition stage,
    int rowIndex,
    List<CellPosition> current,
    List<List<CellPosition>> results, {
    int? maxSolutions,
  }) {
    if (maxSolutions != null && results.length >= maxSolutions) return;

    if (rowIndex == stage.size) {
      // Check full board with validator
      final grid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );
      for (final p in current) {
        grid[p.row][p.col] = CellContent.critter;
      }

      final res = UniversalStageValidator.validate(
        state: GameState(grid: grid),
        stage: stage,
      );

      if (res.passed) {
        results.add(List.from(current));
      }
      return;
    }

    // Try placing a critter in each column of this row
    for (int col = 0; col < stage.size; col++) {
      final pos = CellPosition(rowIndex, col);

      // Fast pruning: check column conflict
      if (current.any((p) => p.col == col)) continue;

      // Fast pruning: check habitat conflict
      final regionId = stage.habitatGrid[rowIndex][col];
      if (current.any((p) => stage.habitatGrid[p.row][p.col] == regionId)) continue;

      // Fast pruning: check 8-neighbor adjacency
      bool touches = false;
      for (final p in current) {
        if ((p.row - rowIndex).abs() <= 1 && (p.col - col).abs() <= 1) {
          touches = true;
          break;
        }
      }
      if (touches) continue;

      // Recurse
      current.add(pos);
      _backtrack(stage, rowIndex + 1, current, results, maxSolutions: maxSolutions);
      current.removeLast();
    }
  }
}
