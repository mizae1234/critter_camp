import '../stage_definition.dart';
import '../../bonus/no_hints_bonus.dart';
import '../../bonus/move_efficiency_bonus.dart';

class StageCatalog {
  /// Stage 1: Sunlit Meadow (4x4 Intro - 2 distinct valid solutions)
  static const StageDefinition stage1 = StageDefinition(
    id: 'stage-001',
    stageNumber: 1,
    name: 'Sunlit Meadow',
    biomeName: 'Camp Entrance',
    size: 4,
    habitatGrid: [
      [0, 0, 1, 1],
      [0, 3, 3, 1],
      [2, 3, 3, 3],
      [2, 2, 3, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 6),
    ],
    rewardCritterId: 'hazel',
    baseAcornsReward: 10,
    description: 'Welcome to camp! Place 1 critter in each of the 4 habitat regions.',
  );

  /// Stage 2: Pine Grove (5x5 Easy - Multiple valid solutions)
  static const StageDefinition stage2 = StageDefinition(
    id: 'stage-002',
    stageNumber: 2,
    name: 'Pine Grove',
    biomeName: 'Forest Trail',
    size: 5,
    habitatGrid: [
      [0, 0, 1, 1, 1],
      [0, 0, 1, 2, 2],
      [3, 3, 2, 2, 2],
      [3, 4, 4, 4, 2],
      [3, 3, 4, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 8),
    ],
    rewardCritterId: 'finn',
    baseAcornsReward: 15,
    description: 'The pine trees shelter 5 cozy regions. Watch out for neighbors!',
  );

  /// Stage 3: Lavender Hollow (5x5 Diagonal Focus)
  static const StageDefinition stage3 = StageDefinition(
    id: 'stage-003',
    stageNumber: 3,
    name: 'Lavender Hollow',
    biomeName: 'Forest Trail',
    size: 5,
    habitatGrid: [
      [0, 0, 0, 1, 1],
      [0, 2, 2, 1, 1],
      [0, 2, 2, 3, 3],
      [4, 4, 2, 3, 3],
      [4, 4, 4, 4, 3],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 9),
    ],
    rewardCritterId: 'pip',
    baseAcornsReward: 15,
    description: 'Fragrant lavender groves require careful diagonal spacing.',
  );

  /// Stage 4: Mossy Glen (6x6 Intermediate)
  static const StageDefinition stage4 = StageDefinition(
    id: 'stage-004',
    stageNumber: 4,
    name: 'Mossy Glen',
    biomeName: 'Willow Brook',
    size: 6,
    habitatGrid: [
      [0, 0, 0, 1, 1, 1],
      [0, 0, 2, 1, 1, 1],
      [2, 2, 2, 2, 3, 3],
      [4, 4, 2, 3, 3, 3],
      [4, 4, 5, 5, 3, 3],
      [4, 5, 5, 5, 5, 5],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
    rewardCritterId: 'moss',
    baseAcornsReward: 20,
    description: 'A lush mossy clearing with 6 sprawling habitats.',
  );

  /// Stage 5: River Bend (6x6 Multi-Solution Showcase)
  /// Explicitly engineered and verified to have multiple distinct valid solutions!
  static const StageDefinition stage5 = StageDefinition(
    id: 'stage-005',
    stageNumber: 5,
    name: 'River Bend',
    biomeName: 'Ancient Hollow',
    size: 6,
    habitatGrid: [
      [0, 0, 0, 1, 1, 1],
      [0, 0, 0, 1, 1, 1],
      [2, 2, 3, 3, 1, 1],
      [2, 2, 3, 3, 4, 4],
      [5, 5, 5, 4, 4, 4],
      [5, 5, 5, 4, 4, 4],
    ],
    bonusObjectives: [
      NoHintsBonus(),
      MoveEfficiencyBonus(maxMoves: 12),
    ],
    rewardCritterId: 'luna',
    baseAcornsReward: 25,
    description: 'A winding river valley where multiple creative paths lead to victory.',
  );

  /// List of all 5 initial stages.
  static const List<StageDefinition> allStages = [
    stage1,
    stage2,
    stage3,
    stage4,
    stage5,
  ];

  static StageDefinition getByNumber(int number) {
    if (number < 1) return stage1;
    if (number > allStages.length) return allStages.last;
    return allStages[number - 1];
  }

  static StageDefinition getById(String id) {
    return allStages.firstWhere(
      (s) => s.id == id,
      orElse: () => stage1,
    );
  }
}
