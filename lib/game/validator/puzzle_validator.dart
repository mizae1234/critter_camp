import '../models/puzzle_cell_state.dart';
import '../models/puzzle_board_data.dart';

class ValidationResult {
  final bool isValid;
  final bool isCompleted;
  final Set<CellPosition> conflictingCells;
  final String? errorMessage;

  const ValidationResult({
    required this.isValid,
    required this.isCompleted,
    required this.conflictingCells,
    this.errorMessage,
  });
}

class PuzzleValidator {
  /// Validates the current board state against the 4 core Critter Camp rules.
  static ValidationResult validate({
    required PuzzleLevelData level,
    required List<List<CellContent>> currentGrid,
  }) {
    final int n = level.size;
    final Set<CellPosition> conflicts = {};
    final List<CellPosition> placedCritters = [];

    // Collect all placed critters
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (currentGrid[r][c] == CellContent.critter) {
          placedCritters.add(CellPosition(r, c));
        }
      }
    }

    String? firstError;

    // Rule 1: Row Constraints (At most 1 critter per row)
    for (int r = 0; r < n; r++) {
      final inRow = placedCritters.where((p) => p.row == r).toList();
      if (inRow.length > 1) {
        conflicts.addAll(inRow);
        firstError ??= 'Row ${r + 1} has multiple critters!';
      }
    }

    // Rule 2: Column Constraints (At most 1 critter per column)
    for (int c = 0; c < n; c++) {
      final inCol = placedCritters.where((p) => p.col == c).toList();
      if (inCol.length > 1) {
        conflicts.addAll(inCol);
        firstError ??= 'Column ${c + 1} has multiple critters!';
      }
    }

    // Rule 3: Habitat Constraints (At most 1 critter per habitat region)
    final Map<int, List<CellPosition>> habitatMap = {};
    for (final p in placedCritters) {
      final int regionId = level.habitatGrid[p.row][p.col];
      habitatMap.putIfAbsent(regionId, () => []).add(p);
    }
    for (final entry in habitatMap.entries) {
      if (entry.value.length > 1) {
        conflicts.addAll(entry.value);
        firstError ??= 'Habitat has multiple critters!';
      }
    }

    // Rule 4: 8-Neighbor Adjacency (Critters cannot touch horizontally, vertically, or diagonally)
    for (int i = 0; i < placedCritters.length; i++) {
      for (int j = i + 1; j < placedCritters.length; j++) {
        final p1 = placedCritters[i];
        final p2 = placedCritters[j];

        final int rowDiff = (p1.row - p2.row).abs();
        final int colDiff = (p1.col - p2.col).abs();

        if (rowDiff <= 1 && colDiff <= 1) {
          conflicts.add(p1);
          conflicts.add(p2);
          firstError ??= 'Critters cannot touch each other!';
        }
      }
    }

    final bool hasNoConflicts = conflicts.isEmpty;
    final bool hasAllCritters = placedCritters.length == n;
    final bool isCompleted = hasNoConflicts && hasAllCritters;

    return ValidationResult(
      isValid: hasNoConflicts,
      isCompleted: isCompleted,
      conflictingCells: conflicts,
      errorMessage: firstError,
    );
  }
}
