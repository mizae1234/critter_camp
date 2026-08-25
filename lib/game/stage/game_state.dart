import '../models/puzzle_cell_state.dart';

class GameState {
  final List<List<CellContent>> grid;
  final int movesCount;
  final int hintsUsed;
  final int elapsedSeconds;

  const GameState({
    required this.grid,
    this.movesCount = 0,
    this.hintsUsed = 0,
    this.elapsedSeconds = 0,
  });

  int get size => grid.length;

  List<CellPosition> get placedCritterPositions {
    final List<CellPosition> list = [];
    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        if (grid[r][c] == CellContent.critter) {
          list.add(CellPosition(r, c));
        }
      }
    }
    return list;
  }

  int get critterCount => placedCritterPositions.length;

  GameState copyWith({
    List<List<CellContent>>? grid,
    int? movesCount,
    int? hintsUsed,
    int? elapsedSeconds,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      movesCount: movesCount ?? this.movesCount,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}
