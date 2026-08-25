import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/game/models/puzzle_cell_state.dart';
import 'package:critter_camp/game/stage/game_state.dart';
import 'package:critter_camp/game/stage/stages/stage_catalog.dart';
import 'package:critter_camp/game/validator/universal_stage_validator.dart';
import 'package:critter_camp/game/solver/stage_solver.dart';

void main() {
  group('PuzzleValidator Legacy Compatibility Tests', () {
    test('Empty board is valid rules-wise but not completed', () {
      final stage = StageCatalog.stage4;
      final emptyGrid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );

      final result = UniversalStageValidator.validate(
        state: GameState(grid: emptyGrid),
        stage: stage,
      );

      expect(result.passed, isFalse);
      expect(result.conflictingCells, isEmpty);
    });

    test('Full correct solution dynamically found passes validation', () {
      final stage = StageCatalog.stage4;
      final solution = StageSolver.findSolution(stage);
      expect(solution, isNotNull);

      final grid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );

      for (final pos in solution!) {
        grid[pos.row][pos.col] = CellContent.critter;
      }

      final result = UniversalStageValidator.validate(
        state: GameState(grid: grid),
        stage: stage,
      );

      expect(result.passed, isTrue);
      expect(result.conflictingCells, isEmpty);
    });

    test('Row conflict detected when 2 critters are in same row', () {
      final stage = StageCatalog.stage4;
      final grid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );

      grid[0][0] = CellContent.critter;
      grid[0][4] = CellContent.critter; // Same row 0

      final result = UniversalStageValidator.validate(
        state: GameState(grid: grid),
        stage: stage,
      );

      expect(result.passed, isFalse);
      expect(result.conflictingCells.contains(const CellPosition(0, 0)), isTrue);
      expect(result.conflictingCells.contains(const CellPosition(0, 4)), isTrue);
    });

    test('8-Neighbor adjacency conflict detected for diagonal touching', () {
      final stage = StageCatalog.stage4;
      final grid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );

      grid[1][1] = CellContent.critter;
      grid[2][2] = CellContent.critter; // Diagonally touching

      final result = UniversalStageValidator.validate(
        state: GameState(grid: grid),
        stage: stage,
      );

      expect(result.passed, isFalse);
      expect(result.conflictingCells.contains(const CellPosition(1, 1)), isTrue);
      expect(result.conflictingCells.contains(const CellPosition(2, 2)), isTrue);
    });
  });
}
