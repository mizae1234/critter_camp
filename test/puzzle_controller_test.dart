import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/game/models/puzzle_cell_state.dart';
import 'package:critter_camp/game/stage/stages/stage_catalog.dart';
import 'package:critter_camp/game/engine/puzzle_controller.dart';
import 'package:critter_camp/game/solver/stage_solver.dart';

void main() {
  group('PuzzleController Tests', () {
    test('Initializes with empty grid and 3 lives', () {
      final controller = PuzzleController(stage: StageCatalog.stage4);
      expect(controller.size, 6);
      expect(controller.lives, 3);
      expect(controller.placedCrittersCount, 0);
      expect(controller.selectedTool, ToolMode.placeCritter);
      expect(controller.isCompleted, isFalse);
      expect(controller.isGameOver, isFalse);
    });

    test('Tapping cell with placeCritter tool toggles critter', () {
      final controller = PuzzleController(stage: StageCatalog.stage4);
      controller.handleCellTap(0, 2);
      expect(controller.grid[0][2], CellContent.critter);
      expect(controller.placedCrittersCount, 1);
      expect(controller.canUndo, isTrue);

      controller.handleCellTap(0, 2);
      expect(controller.grid[0][2], CellContent.empty);
      expect(controller.placedCrittersCount, 0);
    });

    test('Undo reverts last move', () {
      final controller = PuzzleController(stage: StageCatalog.stage4);
      controller.handleCellTap(0, 2);
      expect(controller.grid[0][2], CellContent.critter);

      controller.undo();
      expect(controller.grid[0][2], CellContent.empty);
    });

    test('Hint places valid piece dynamically', () {
      final controller = PuzzleController(stage: StageCatalog.stage4);
      expect(controller.hintsRemaining, 3);

      final used = controller.useHint();
      expect(used, isTrue);
      expect(controller.hintsRemaining, 2);
      expect(controller.placedCrittersCount, 1);
    });

    test('Placing full solution triggers onStageCompleted callback', () {
      final controller = PuzzleController(stage: StageCatalog.stage4);
      final solution = StageSolver.findSolution(StageCatalog.stage4);
      expect(solution, isNotNull);

      bool won = false;
      controller.onStageCompleted = (res) => won = true;

      for (final pos in solution!) {
        controller.handleCellTap(pos.row, pos.col);
      }

      expect(controller.isCompleted, isTrue);
      expect(won, isTrue);
    });
  });
}
