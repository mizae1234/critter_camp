import 'puzzle_cell_state.dart';

class PuzzleMove {
  final CellPosition position;
  final CellContent previousContent;
  final CellContent newContent;

  const PuzzleMove({
    required this.position,
    required this.previousContent,
    required this.newContent,
  });
}
