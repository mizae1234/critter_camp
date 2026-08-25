import 'puzzle_cell_state.dart';
import 'habitat_region.dart';

class PuzzleLevelData {
  final int levelNumber;
  final String title;
  final String biomeName;
  final int size; // NxN (5, 6, 7, 8)
  final List<List<int>> habitatGrid; // Matrix of region IDs
  final List<CellPosition> solution; // Exact positions of critters
  final String rewardCritterId; // Critter unlocked upon clear

  const PuzzleLevelData({
    required this.levelNumber,
    required this.title,
    required this.biomeName,
    required this.size,
    required this.habitatGrid,
    required this.solution,
    this.rewardCritterId = 'hazel',
  });

  HabitatRegion getHabitatAt(int row, int col) {
    final int regionId = habitatGrid[row][col];
    return HabitatRegion.byIndex(regionId);
  }
}
