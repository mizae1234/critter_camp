import '../models/leaderboard_entry.dart';
import '../mock/mock_leaderboard_data.dart';

abstract class LeaderboardRepository {
  Future<List<LeaderboardEntry>> getLeaderboard({String timeframe = 'daily'});
}

class MockLeaderboardRepository implements LeaderboardRepository {
  @override
  Future<List<LeaderboardEntry>> getLeaderboard({String timeframe = 'daily'}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return MockLeaderboardData.dailyEntries;
  }
}
