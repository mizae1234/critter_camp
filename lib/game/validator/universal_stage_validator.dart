import '../models/puzzle_cell_state.dart';
import '../stage/game_state.dart';
import '../stage/stage_definition.dart';
import '../goals/stage_goal.dart';
import '../rules/stage_rule.dart';
import '../bonus/bonus_objective.dart';
import 'stage_validation_result.dart';

class UniversalStageValidator {
  /// Evaluates the game state against the stage's goals and rules.
  /// A stage passes when ALL required goals are completed AND NO blocking rules are violated.
  static StageValidationResult validate({
    required GameState state,
    required StageDefinition stage,
  }) {
    // 1. Evaluate all Rules
    final List<RuleEvaluation> evaluations = [];
    final Set<CellPosition> allConflicts = {};
    String? firstViolationMessage;
    bool hasBlockingViolation = false;

    for (final rule in stage.rules) {
      final eval = rule.evaluate(state, stage);
      evaluations.add(eval);

      if (!eval.isValid) {
        allConflicts.addAll(eval.conflictingCells);
        firstViolationMessage ??= eval.violationMessage;
        if (eval.isBlocking) {
          hasBlockingViolation = true;
        }
      }
    }

    // 2. Evaluate all Goals
    final List<StageGoal> completedGoals = [];
    final List<StageGoal> pendingGoals = [];

    for (final goal in stage.goals) {
      if (goal.isCompleted(state, stage)) {
        completedGoals.add(goal);
      } else {
        pendingGoals.add(goal);
      }
    }

    final bool allGoalsAchieved = pendingGoals.isEmpty;
    final bool passed = allGoalsAchieved && !hasBlockingViolation;

    // 3. Evaluate Bonus Objectives for Star Rating
    final List<BonusObjective> completedBonuses = [];
    int stars = 0;

    if (passed) {
      stars = 1; // 1 Star for solving the stage
      for (final bonus in stage.bonusObjectives) {
        if (bonus.isAchieved(state, stage)) {
          completedBonuses.add(bonus);
          stars++;
        }
      }
      if (stars > 3) stars = 3;
    }

    return StageValidationResult(
      passed: passed,
      isComplete: allGoalsAchieved,
      goalsCompleted: completedGoals,
      goalsPending: pendingGoals,
      ruleEvaluations: evaluations,
      conflictingCells: allConflicts,
      primaryViolationMessage: firstViolationMessage,
      bonusObjectivesCompleted: completedBonuses,
      starsEarned: stars,
    );
  }
}
