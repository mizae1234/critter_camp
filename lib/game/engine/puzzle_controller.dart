import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/puzzle_cell_state.dart';
import '../models/puzzle_board_data.dart';
import '../models/puzzle_move.dart';
import '../validator/puzzle_validator.dart';

enum ToolMode {
  placeCritter,
  markX,
}

class PuzzleController extends ChangeNotifier {
  final PuzzleLevelData level;
  late List<List<CellContent>> _grid;
  final List<PuzzleMove> _history = [];
  
  ToolMode _selectedTool = ToolMode.placeCritter;
  int _lives = 3;
  int _hintsRemaining = 3;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isZenMode = false;
  bool _isPatternMode = false;
  bool _isGameOver = false;
  bool _isCompleted = false;

  Set<CellPosition> _conflictingCells = {};
  String? _lastError;

  // Callbacks
  VoidCallback? onLevelCompleted;
  VoidCallback? onWrongMove;
  VoidCallback? onGameOver;

  PuzzleController({
    required this.level,
    bool isZenMode = false,
    bool isPatternMode = false,
  }) {
    _isZenMode = isZenMode;
    _isPatternMode = isPatternMode;
    _initializeBoard();
    _startTimer();
  }

  // Getters
  int get size => level.size;
  List<List<CellContent>> get grid => _grid;
  ToolMode get selectedTool => _selectedTool;
  int get lives => _lives;
  int get hintsRemaining => _hintsRemaining;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isZenMode => _isZenMode;
  bool get isPatternMode => _isPatternMode;
  bool get isGameOver => _isGameOver;
  bool get isCompleted => _isCompleted;
  Set<CellPosition> get conflictingCells => _conflictingCells;
  String? get lastError => _lastError;
  bool get canUndo => _history.isNotEmpty;

  int get placedCrittersCount {
    int count = 0;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_grid[r][c] == CellContent.critter) count++;
      }
    }
    return count;
  }

  void _initializeBoard() {
    _grid = List.generate(
      size,
      (_) => List.filled(size, CellContent.empty),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isCompleted && !_isGameOver) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  void selectTool(ToolMode tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  void togglePatternMode() {
    _isPatternMode = !_isPatternMode;
    notifyListeners();
  }

  /// Primary cell interaction handler
  void handleCellTap(int row, int col) {
    if (_isCompleted || _isGameOver) return;

    final CellPosition pos = CellPosition(row, col);
    final CellContent current = _grid[row][col];
    CellContent next;

    if (_selectedTool == ToolMode.placeCritter) {
      // Toggle empty -> critter -> empty
      next = (current == CellContent.critter) ? CellContent.empty : CellContent.critter;
    } else {
      // Toggle empty -> xMark -> empty
      next = (current == CellContent.xMark) ? CellContent.empty : CellContent.xMark;
    }

    _applyMove(pos, next);
  }

  /// Secondary interaction handler (e.g. Long press or double tap to quick toggle X)
  void handleCellLongPress(int row, int col) {
    if (_isCompleted || _isGameOver) return;
    final CellPosition pos = CellPosition(row, col);
    final CellContent current = _grid[row][col];
    final CellContent next = (current == CellContent.xMark) ? CellContent.empty : CellContent.xMark;
    _applyMove(pos, next);
  }

  void _applyMove(CellPosition pos, CellContent newContent) {
    final CellContent previous = _grid[pos.row][pos.col];
    if (previous == newContent) return;

    _grid[pos.row][pos.col] = newContent;
    _history.add(PuzzleMove(
      position: pos,
      previousContent: previous,
      newContent: newContent,
    ));

    // Validate board
    final validation = PuzzleValidator.validate(
      level: level,
      currentGrid: _grid,
    );

    _conflictingCells = validation.conflictingCells;
    _lastError = validation.errorMessage;

    // Check for wrong move penalty
    if (newContent == CellContent.critter && _conflictingCells.contains(pos)) {
      if (!_isZenMode) {
        _lives = (_lives - 1).clamp(0, 3);
        onWrongMove?.call();
        if (_lives == 0) {
          _isGameOver = true;
          onGameOver?.call();
        }
      }
    }

    // Check for victory
    if (validation.isCompleted) {
      _isCompleted = true;
      _timer?.cancel();
      onLevelCompleted?.call();
    }

    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty || _isCompleted) return;

    final lastMove = _history.removeLast();
    _grid[lastMove.position.row][lastMove.position.col] = lastMove.previousContent;

    // Re-validate
    final validation = PuzzleValidator.validate(
      level: level,
      currentGrid: _grid,
    );
    _conflictingCells = validation.conflictingCells;
    _lastError = validation.errorMessage;

    notifyListeners();
  }

  /// Use Hint: Reveals next correct move from solution
  bool useHint() {
    if (_hintsRemaining <= 0 || _isCompleted || _isGameOver) return false;

    // 1. Find a solution critter that is not placed yet
    for (final solPos in level.solution) {
      if (_grid[solPos.row][solPos.col] != CellContent.critter) {
        _applyMove(solPos, CellContent.critter);
        _hintsRemaining--;
        notifyListeners();
        return true;
      }
    }

    // 2. Mark an invalid cell with X
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final pos = CellPosition(r, c);
        if (!level.solution.contains(pos) && _grid[r][c] == CellContent.empty) {
          _applyMove(pos, CellContent.xMark);
          _hintsRemaining--;
          notifyListeners();
          return true;
        }
      }
    }

    return false;
  }

  void restartLevel() {
    _initializeBoard();
    _history.clear();
    _lives = 3;
    _elapsedSeconds = 0;
    _isGameOver = false;
    _isCompleted = false;
    _conflictingCells.clear();
    _lastError = null;
    _startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
