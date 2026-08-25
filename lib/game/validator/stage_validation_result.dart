import '../models/puzzle_cell_state.dart';
import '../goals/stage_goal.dart';
import '../rules/stage_rule.dart';
import '../bonus/bonus_objective.dart';

class StageValidationResult {
  final bool passed;
  final bool isComplete;
  final List<StageGoal> goalsCompleted;
  final List<StageGoal> goalsPending;
  final List<RuleEvaluation> ruleEvaluations;
  final Set<CellPosition> conflictingCells;
  final String? primaryViolationMessage;
  final List<BonusObjective> bonusObjectivesCompleted;
  final int starsEarned; // 0, 1, 2, or 3 stars

  const StageValidationResult({
    required this.passed,
    required this.isComplete,
    required this.goalsCompleted,
    required this.goalsPending,
    required this.ruleEvaluations,
    required this.conflictingCells,
    this.primaryViolationMessage,
    required this.bonusObjectivesCompleted,
    required this.starsEarned,
  });

  bool get hasRuleViolations => conflictingCells.isNotEmpty;

  static const StageValidationResult initial = StageValidationResult(
    passed: false,
    isComplete: false,
    goalsCompleted: [],
    goalsPending: [],
    ruleEvaluations: [],
    conflictingCells: {},
    primaryViolationMessage: null,
    bonusObjectivesCompleted: [],
    starsEarned: 0,
  );
}
