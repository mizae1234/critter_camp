import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/puzzle_cell_state.dart';
import '../models/puzzle_move.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import '../validator/stage_validation_result.dart';
import '../validator/universal_stage_validator.dart';
import '../solver/stage_solver.dart';
import '../../services/audio/audio_service.dart';

enum ToolMode {
  placeCritter,
  markX,
}

class PuzzleController extends ChangeNotifier {
  final StageDefinition stage;
  late List<List<CellContent>> _grid;
  final List<PuzzleMove> _history = [];
  
  ToolMode _selectedTool = ToolMode.placeCritter;
  int _lives = 3;
  int _hintsRemaining = 3;
  int _hintsUsed = 0;
  int _movesCount = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isZenMode = false;
  bool _isPatternMode = false;
  bool _isGameOver = false;
  bool _isCompleted = false;
  int _secondsSinceLastInteraction = 0;
  bool _nudgeDismissedThisTurn = false;

  StageValidationResult _lastValidation = StageValidationResult.initial;
  Set<CellPosition> _conflictingCells = {};
  String? _lastError;

  final AudioService? audioService;

  // Callbacks
  void Function(StageValidationResult result)? onStageCompleted;
  VoidCallback? onLevelCompleted; // For backward compatibility
  VoidCallback? onWrongMove;
  VoidCallback? onGameOver;

  PuzzleController({
    required this.stage,
    this.audioService,
    bool isZenMode = false,
    bool isPatternMode = false,
  }) {
    _isZenMode = isZenMode;
    _isPatternMode = isPatternMode;
    _initializeBoard();
    _startTimer();
  }

  // Getters
  int get size => stage.size;
  List<List<CellContent>> get grid => _grid;
  ToolMode get selectedTool => _selectedTool;
  int get lives => _lives;
  int get hintsRemaining => _hintsRemaining;
  int get hintsUsed => _hintsUsed;
  int get movesCount => _movesCount;
  int get elapsedSeconds => _elapsedSeconds;
  bool get isZenMode => _isZenMode;
  bool get isPatternMode => _isPatternMode;
  bool get isGameOver => _isGameOver;
  bool get isCompleted => _isCompleted;
  bool get shouldShowHintNudge => _secondsSinceLastInteraction >= 35 && !_nudgeDismissedThisTurn && !_isCompleted && !_isGameOver;
  StageValidationResult get lastValidation => _lastValidation;
  Set<CellPosition> get conflictingCells => _conflictingCells;
  String? get lastError => _lastError;
  bool get canUndo => _history.isNotEmpty;

  void dismissHintNudge() {
    _nudgeDismissedThisTurn = true;
    notifyListeners();
  }

  void resetInactivity() {
    _secondsSinceLastInteraction = 0;
    _nudgeDismissedThisTurn = false;
  }

  GameState get currentGameState => GameState(
    grid: _grid,
    movesCount: _movesCount,
    hintsUsed: _hintsUsed,
    elapsedSeconds: _elapsedSeconds,
  );

  GameState get state => currentGameState;

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
    _grid = stage.createInitialGrid();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isCompleted && !_isGameOver) {
        _elapsedSeconds++;
        _secondsSinceLastInteraction++;
        notifyListeners();
      }
    });
  }

  void selectTool(ToolMode tool) {
    _selectedTool = tool;
    resetInactivity();
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

  /// Secondary interaction handler (e.g. Long press to quick toggle X)
  void handleCellLongPress(int row, int col) {
    if (_isCompleted || _isGameOver) return;
    final CellPosition pos = CellPosition(row, col);
    final CellContent current = _grid[row][col];
    final CellContent next = (current == CellContent.xMark) ? CellContent.empty : CellContent.xMark;
    _applyMove(pos, next);
  }

  /// Direct critter placement helper (e.g. for dynamic hint guidance)
  void placeCritterAt(int row, int col) {
    if (_isCompleted || _isGameOver) return;
    final pos = CellPosition(row, col);
    _applyMove(pos, CellContent.critter);
    notifyListeners();
  }

  void _applyMove(CellPosition pos, CellContent newContent) {
    final CellContent previous = _grid[pos.row][pos.col];
    if (previous == newContent) return;

    resetInactivity();
    _grid[pos.row][pos.col] = newContent;
    _movesCount++;
    _history.add(PuzzleMove(
      position: pos,
      previousContent: previous,
      newContent: newContent,
    ));

    // Play tactile sound effect
    if (newContent == CellContent.critter) {
      audioService?.playPlaceCritter();
    } else if (newContent == CellContent.xMark) {
      audioService?.playMarkX();
    } else {
      audioService?.playUndo();
    }

    // Validate board using UniversalStageValidator
    _validateCurrentState(newCritterPlacedAt: (newContent == CellContent.critter) ? pos : null);
  }

  void _validateCurrentState({CellPosition? newCritterPlacedAt}) {
    _lastValidation = UniversalStageValidator.validate(
      state: currentGameState,
      stage: stage,
    );

    _conflictingCells = _lastValidation.conflictingCells;
    _lastError = _lastValidation.primaryViolationMessage;

    // Check for wrong move penalty on newly placed critter
    if (newCritterPlacedAt != null && _conflictingCells.contains(newCritterPlacedAt)) {
      audioService?.playConflict();
      if (!_isZenMode) {
        _lives = (_lives - 1).clamp(0, 3);
        onWrongMove?.call();
        if (_lives == 0) {
          _isGameOver = true;
          onGameOver?.call();
        }
      }
    }

    // Check for stage pass
    if (_lastValidation.passed) {
      _isCompleted = true;
      _timer?.cancel();
      audioService?.playVictory();
      onStageCompleted?.call(_lastValidation);
      onLevelCompleted?.call();
    }

    notifyListeners();
  }

  void undo() {
    if (_history.isEmpty || _isCompleted) return;

    resetInactivity();
    final lastMove = _history.removeLast();
    _grid[lastMove.position.row][lastMove.position.col] = lastMove.previousContent;
    audioService?.playUndo();

    _validateCurrentState();
  }

  /// Dynamic Hint: Finds a valid continuation on-the-fly without hardcoded solutions
  bool useHint() {
    if (_hintsRemaining <= 0 || _isCompleted || _isGameOver) return false;

    // Use on-the-fly dynamic solver to find a valid solution
    final validSolution = StageSolver.findSolution(stage, fromState: currentGameState) ??
        StageSolver.findSolution(stage);

    if (validSolution == null) return false;

    // 1. Place a valid unplaced critter
    for (final solPos in validSolution) {
      if (_grid[solPos.row][solPos.col] != CellContent.critter) {
        _hintsRemaining--;
        _hintsUsed++;
        _applyMove(solPos, CellContent.critter);
        return true;
      }
    }

    // 2. Or place a safe X mark
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final pos = CellPosition(r, c);
        if (!validSolution.contains(pos) && _grid[r][c] == CellContent.empty) {
          _hintsRemaining--;
          _hintsUsed++;
          _applyMove(pos, CellContent.xMark);
          return true;
        }
      }
    }

    return false;
  }

  /// Restores stage to the exact deterministic initial definition
  void resetStage() {
    _initializeBoard();
    _history.clear();
    _lives = 3;
    _hintsUsed = 0;
    _movesCount = 0;
    _elapsedSeconds = 0;
    _isGameOver = false;
    _isCompleted = false;
    _conflictingCells.clear();
    _lastError = null;
    _lastValidation = StageValidationResult.initial;
    _startTimer();
    notifyListeners();
  }

  void restartLevel() => resetStage(); // Alias

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
