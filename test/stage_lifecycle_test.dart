import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/game/stage/stages/stage_catalog.dart';
import 'package:critter_camp/game/engine/puzzle_controller.dart';
import 'package:critter_camp/game/solver/stage_solver.dart';

void main() {
  group('Stage Lifecycle & Dynamic Controller Tests', () {
    test('Initializes with StageDefinition and 3 lives', () {
      final stage = StageCatalog.stage1;
      final controller = PuzzleController(stage: stage);

      expect(controller.size, 4);
      expect(controller.lives, 3);
      expect(controller.movesCount, 0);
      expect(controller.hintsUsed, 0);
      expect(controller.hintsRemaining, 3);
      expect(controller.isCompleted, isFalse);
      expect(controller.isGameOver, isFalse);
    });

    test('Stage Reset restores exact initial board state and resets counters', () {
      final stage = StageCatalog.stage1;
      final controller = PuzzleController(stage: stage);

      // Make moves
      controller.handleCellTap(0, 0);
      controller.handleCellTap(1, 1);
      expect(controller.movesCount, 2);
      expect(controller.placedCrittersCount, 2);

      // Reset stage
      controller.resetStage();

      expect(controller.movesCount, 0);
      expect(controller.hintsUsed, 0);
      expect(controller.placedCrittersCount, 0);
      expect(controller.lives, 3);
      expect(controller.conflictingCells, isEmpty);
      expect(controller.isGameOver, isFalse);
      expect(controller.isCompleted, isFalse);
    });

    test('Dynamic Hint uses StageSolver to place a valid critter without pre-stored answers', () {
      final stage = StageCatalog.stage1;
      final controller = PuzzleController(stage: stage);

      expect(controller.hintsRemaining, 3);
      expect(controller.hintsUsed, 0);

      final success = controller.useHint();
      expect(success, isTrue);
      expect(controller.hintsRemaining, 2);
      expect(controller.hintsUsed, 1);
      expect(controller.placedCrittersCount, 1);
    });

    test('Solving stage triggers onStageCompleted with calculated stars', () {
      final stage = StageCatalog.stage1;
      final controller = PuzzleController(stage: stage);

      final solutions = StageSolver.findAllSolutions(stage);
      expect(solutions.isNotEmpty, isTrue);

      final validSolution = solutions.first;

      bool stageWon = false;
      int earnedStars = 0;
      controller.onStageCompleted = (res) {
        stageWon = true;
        earnedStars = res.starsEarned;
      };

      // Place all critters according to the valid solution
      for (final pos in validSolution) {
        controller.handleCellTap(pos.row, pos.col);
      }

      expect(controller.isCompleted, isTrue);
      expect(stageWon, isTrue);
      expect(earnedStars, greaterThanOrEqualTo(1));
    });
  });
}
