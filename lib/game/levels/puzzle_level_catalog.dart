import '../models/puzzle_cell_state.dart';
import '../models/puzzle_board_data.dart';

class PuzzleLevelCatalog {
  static final PuzzleLevelData level1 = PuzzleLevelData(
    levelNumber: 1,
    title: 'First Grove',
    biomeName: 'Camp Entrance',
    size: 5,
    habitatGrid: [
      [0, 0, 1, 1, 1],
      [0, 0, 1, 2, 2],
      [3, 3, 1, 2, 2],
      [3, 4, 4, 4, 2],
      [3, 3, 4, 4, 4],
    ],
    solution: const [
      CellPosition(0, 1),
      CellPosition(1, 3),
      CellPosition(2, 0),
      CellPosition(3, 4),
      CellPosition(4, 2),
    ],
    rewardCritterId: 'pip',
  );

  /// Official Level 18 matching Stitch screens 03, 04, 05, 06, 15
  static final PuzzleLevelData level18 = PuzzleLevelData(
    levelNumber: 18,
    title: 'Sunlit Meadow',
    biomeName: 'Forest Trail',
    size: 6,
    habitatGrid: [
      [0, 0, 0, 1, 1, 1],
      [0, 2, 2, 1, 1, 3],
      [2, 2, 2, 4, 3, 3],
      [5, 2, 4, 4, 4, 3],
      [5, 5, 4, 4, 3, 3],
      [5, 5, 5, 4, 4, 4],
    ],
    solution: const [
      CellPosition(0, 2),
      CellPosition(1, 4),
      CellPosition(2, 0),
      CellPosition(3, 5),
      CellPosition(4, 1),
      CellPosition(5, 3),
    ],
    rewardCritterId: 'hazel',
  );

  /// Daily Challenge 7x7 level matching Stitch screen 11
  static final PuzzleLevelData daily7x7 = PuzzleLevelData(
    levelNumber: 25,
    title: 'The Great Oak Daily',
    biomeName: 'Ancient Hollow',
    size: 7,
    habitatGrid: [
      [0, 0, 1, 1, 2, 2, 2],
      [0, 0, 1, 1, 2, 2, 3],
      [0, 4, 4, 1, 2, 3, 3],
      [4, 4, 4, 5, 5, 3, 3],
      [4, 4, 5, 5, 5, 6, 6],
      [4, 5, 5, 5, 6, 6, 6],
      [5, 5, 5, 6, 6, 6, 6],
    ],
    solution: const [
      CellPosition(0, 1),
      CellPosition(1, 3),
      CellPosition(2, 5),
      CellPosition(3, 0),
      CellPosition(4, 2),
      CellPosition(5, 4),
      CellPosition(6, 6),
    ],
    rewardCritterId: 'finn',
  );

  /// 8x8 Master Level
  static final PuzzleLevelData level50 = PuzzleLevelData(
    levelNumber: 50,
    title: 'Master Sanctuary',
    biomeName: 'Starry Peaks',
    size: 8,
    habitatGrid: [
      [0, 0, 1, 1, 2, 2, 3, 3],
      [0, 0, 1, 1, 2, 2, 3, 3],
      [4, 4, 1, 1, 2, 5, 3, 3],
      [4, 4, 4, 6, 6, 5, 5, 3],
      [4, 4, 6, 6, 6, 5, 5, 7],
      [4, 6, 6, 6, 7, 7, 7, 7],
      [6, 6, 6, 7, 7, 7, 7, 7],
      [6, 6, 7, 7, 7, 7, 7, 7],
    ],
    solution: const [
      CellPosition(0, 1),
      CellPosition(1, 4),
      CellPosition(2, 6),
      CellPosition(3, 0),
      CellPosition(4, 2),
      CellPosition(5, 5),
      CellPosition(6, 7),
      CellPosition(7, 3),
    ],
    rewardCritterId: 'clover',
  );

  static List<PuzzleLevelData> getAllLevels() {
    return [level1, level18, daily7x7, level50];
  }

  static PuzzleLevelData getByNumber(int levelNum) {
    if (levelNum == 18) return level18;
    if (levelNum == 25) return daily7x7;
    if (levelNum == 50) return level50;
    return level1;
  }
}
