class UserProgress {
  final int currentLevel;
  final List<int> completedLevels;
  final int totalStars;
  final int acorns;
  final int streakDays;

  const UserProgress({
    required this.currentLevel,
    required this.completedLevels,
    required this.totalStars,
    required this.acorns,
    required this.streakDays,
  });

  bool isLevelUnlocked(int level) => level <= currentLevel || completedLevels.contains(level);
  bool isLevelCompleted(int level) => completedLevels.contains(level);
}
