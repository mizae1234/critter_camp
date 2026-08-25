import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/game/models/puzzle_cell_state.dart';
import 'package:critter_camp/game/stage/game_state.dart';
import 'package:critter_camp/game/stage/stages/stage_catalog.dart';
import 'package:critter_camp/game/validator/universal_stage_validator.dart';
import 'package:critter_camp/game/solver/stage_solver.dart';

void main() {
  group('UniversalStageValidator & Multi-Solution Tests', () {
    test('Empty board is valid rules-wise but incomplete for goals', () {
      final stage = StageCatalog.stage1;
      final emptyGrid = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );

      final result = UniversalStageValidator.validate(
        state: GameState(grid: emptyGrid),
        stage: stage,
      );

      expect(result.passed, isFalse);
      expect(result.hasRuleViolations, isFalse);
      expect(result.conflictingCells, isEmpty);
      expect(result.goalsPending.isNotEmpty, isTrue);
    });

    test('Stage 1 (4x4) has at least 2 distinct valid solutions that both PASS', () {
      final stage = StageCatalog.stage1;
      final allSolutions = StageSolver.findAllSolutions(stage);

      expect(allSolutions.length, greaterThanOrEqualTo(2),
          reason: 'Stage 1 must have multiple valid solutions');

      // Test Solution A
      final gridA = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );
      for (final pos in allSolutions[0]) {
        gridA[pos.row][pos.col] = CellContent.critter;
      }
      final resultA = UniversalStageValidator.validate(
        state: GameState(grid: gridA),
        stage: stage,
      );
      expect(resultA.passed, isTrue);
      expect(resultA.hasRuleViolations, isFalse);
      expect(resultA.starsEarned, greaterThanOrEqualTo(1));

      // Test Solution B (Distinct from A)
      final gridB = List.generate(
        stage.size,
        (_) => List.filled(stage.size, CellContent.empty),
      );
      for (final pos in allSolutions[1]) {
        gridB[pos.row][pos.col] = CellContent.critter;
      }
      final resultB = UniversalStageValidator.validate(
        state: GameState(grid: gridB),
        stage: stage,
      );
      expect(resultB.passed, isTrue);
      expect(resultB.hasRuleViolations, isFalse);
    });

    test('Stage 5 (River Bend 6x6) has MULTIPLE PROVEN DISTINCT VALID SOLUTIONS that all PASS', () {
      final stage = StageCatalog.stage5;
      final allSolutions = StageSolver.findAllSolutions(stage);

      expect(allSolutions.length, greaterThanOrEqualTo(2),
          reason: 'Stage 5 must support multiple distinct player solutions');

      // Verify Solution 1
      final sol1 = allSolutions[0];
      final grid1 = List.generate(stage.size, (_) => List.filled(stage.size, CellContent.empty));
      for (final p in sol1) {
        grid1[p.row][p.col] = CellContent.critter;
      }
      final res1 = UniversalStageValidator.validate(state: GameState(grid: grid1), stage: stage);
      expect(res1.passed, isTrue);
      expect(res1.hasRuleViolations, isFalse);

      // Verify Solution 2
      final sol2 = allSolutions[1];
      final grid2 = List.generate(stage.size, (_) => List.filled(stage.size, CellContent.empty));
      for (final p in sol2) {
        grid2[p.row][p.col] = CellContent.critter;
      }
      final res2 = UniversalStageValidator.validate(state: GameState(grid: grid2), stage: stage);
      expect(res2.passed, isTrue);
      expect(res2.hasRuleViolations, isFalse);

      // Confirm they are actually distinct placements
      final set1 = sol1.toSet();
      final set2 = sol2.toSet();
      expect(set1 == set2, isFalse, reason: 'Solutions must be distinct arrangements');
    });

    test('Rule Violation: Diagonal touching critters fails validation and marks conflict', () {
      final stage = StageCatalog.stage5;
      final grid = List.generate(stage.size, (_) => List.filled(stage.size, CellContent.empty));

      grid[1][1] = CellContent.critter;
      grid[2][2] = CellContent.critter; // Touching diagonally

      final result = UniversalStageValidator.validate(
        state: GameState(grid: grid),
        stage: stage,
      );

      expect(result.passed, isFalse);
      expect(result.hasRuleViolations, isTrue);
      expect(result.conflictingCells.contains(const CellPosition(1, 1)), isTrue);
      expect(result.conflictingCells.contains(const CellPosition(2, 2)), isTrue);
      expect(result.primaryViolationMessage, isNotNull);
    });

    test('All 30 Stages in StageCatalog have at least one verified solvable solution and valid metadata', () {
      expect(StageCatalog.allStages.length, 30);

      for (final stage in StageCatalog.allStages) {
        // 1. Verify mathematical solvability
        final solution = StageSolver.findSolution(stage);
        expect(solution, isNotNull,
            reason: 'Stage ${stage.stageNumber}: ${stage.name} must be mathematically solvable');
        expect(solution!.length, stage.size);

        // 2. Verify metadata
        expect(stage.chapterNumber, inInclusiveRange(1, 6));
        expect(stage.chapterName.isNotEmpty, isTrue);
        expect(stage.storySpeaker.isNotEmpty, isTrue);
        expect(stage.speakerEmoji.isNotEmpty, isTrue);
        expect(stage.storyTextEn.isNotEmpty, isTrue);
        expect(stage.storyTextTh.isNotEmpty, isTrue);
        expect(stage.rewardCritterId.isNotEmpty, isTrue);
      }
    });
  });
}
