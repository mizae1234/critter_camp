import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/game/models/puzzle_cell_state.dart';
import 'package:critter_camp/game/levels/puzzle_level_catalog.dart';
import 'package:critter_camp/game/validator/puzzle_validator.dart';

void main() {
  group('PuzzleValidator Tests', () {
    test('Empty board is valid but not completed', () {
      final level = PuzzleLevelCatalog.level18;
      final emptyGrid = List.generate(
        level.size,
        (_) => List.filled(level.size, CellContent.empty),
      );

      final result = PuzzleValidator.validate(
        level: level,
        currentGrid: emptyGrid,
      );

      expect(result.isValid, isTrue);
      expect(result.isCompleted, isFalse);
      expect(result.conflictingCells, isEmpty);
    });

    test('Full correct solution completes level 18', () {
      final level = PuzzleLevelCatalog.level18;
      final grid = List.generate(
        level.size,
        (_) => List.filled(level.size, CellContent.empty),
      );

      // Place solution critters: (0,2), (1,4), (2,0), (3,5), (4,1), (5,3)
      for (final pos in level.solution) {
        grid[pos.row][pos.col] = CellContent.critter;
      }

      final result = PuzzleValidator.validate(
        level: level,
        currentGrid: grid,
      );

      expect(result.isValid, isTrue);
      expect(result.isCompleted, isTrue);
      expect(result.conflictingCells, isEmpty);
    });

    test('Row conflict detected when 2 critters are in same row', () {
      final level = PuzzleLevelCatalog.level18;
      final grid = List.generate(
        level.size,
        (_) => List.filled(level.size, CellContent.empty),
      );

      grid[0][0] = CellContent.critter;
      grid[0][4] = CellContent.critter; // Same row 0

      final result = PuzzleValidator.validate(
        level: level,
        currentGrid: grid,
      );

      expect(result.isValid, isFalse);
      expect(result.isCompleted, isFalse);
      expect(result.conflictingCells.contains(const CellPosition(0, 0)), isTrue);
      expect(result.conflictingCells.contains(const CellPosition(0, 4)), isTrue);
    });

    test('8-Neighbor adjacency conflict detected for diagonal touching', () {
      final level = PuzzleLevelCatalog.level18;
      final grid = List.generate(
        level.size,
        (_) => List.filled(level.size, CellContent.empty),
      );

      grid[1][1] = CellContent.critter;
      grid[2][2] = CellContent.critter; // Diagonally touching

      final result = PuzzleValidator.validate(
        level: level,
        currentGrid: grid,
      );

      expect(result.isValid, isFalse);
      expect(result.conflictingCells.contains(const CellPosition(1, 1)), isTrue);
      expect(result.conflictingCells.contains(const CellPosition(2, 2)), isTrue);
    });
  });
}
