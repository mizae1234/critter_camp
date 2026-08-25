import '../../core/storage/local_storage.dart';
import '../models/user_progress.dart';

abstract class ProgressRepository {
  Future<UserProgress> getUserProgress();
  Future<void> completeLevel(int level, int stars, int acornsReward);
}

class LocalProgressRepository implements ProgressRepository {
  final LocalStorage storage;

  LocalProgressRepository(this.storage);

  @override
  Future<UserProgress> getUserProgress() async {
    final completedStrs = storage.getCompletedLevels();
    final completedInts = completedStrs.map((s) => int.tryParse(s) ?? 0).where((i) => i > 0).toList();

    return UserProgress(
      currentLevel: storage.getCurrentLevel(),
      completedLevels: completedInts,
      totalStars: storage.getStars(),
      acorns: storage.getAcorns(),
      streakDays: storage.getStreakDays(),
    );
  }

  @override
  Future<void> completeLevel(int level, int stars, int acornsReward) async {
    await storage.markLevelCompleted(level);
    if (level >= storage.getCurrentLevel()) {
      await storage.setCurrentLevel(level + 1);
    }
    await storage.addStars(stars);
    await storage.addAcorns(acornsReward);
  }
}
