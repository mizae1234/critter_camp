import '../models/leaderboard_entry.dart';

class MockLeaderboardData {
  static final List<LeaderboardEntry> dailyEntries = [
    const LeaderboardEntry(rank: 1, playerName: 'LunaFox', avatarEmoji: '🦊', score: 9850, solveTime: '0:42', countryCode: 'TH'),
    const LeaderboardEntry(rank: 2, playerName: 'MossCamper', avatarEmoji: '🐸', score: 9720, solveTime: '0:48', countryCode: 'TH'),
    const LeaderboardEntry(rank: 3, playerName: 'NoriOtter', avatarEmoji: '🦦', score: 9610, solveTime: '0:54', countryCode: 'JP'),
    const LeaderboardEntry(rank: 4, playerName: 'AcornSeeker', avatarEmoji: '🐿️', score: 9540, solveTime: '1:02', countryCode: 'US'),
    const LeaderboardEntry(rank: 5, playerName: 'StarryPine', avatarEmoji: '🌲', score: 9480, solveTime: '1:05', countryCode: 'TH'),
    const LeaderboardEntry(rank: 6, playerName: 'Dewdrop', avatarEmoji: '💧', score: 9420, solveTime: '1:12', countryCode: 'KR'),
    const LeaderboardEntry(rank: 7, playerName: 'FernWanderer', avatarEmoji: '🌿', score: 9380, solveTime: '1:18', countryCode: 'TH'),
    const LeaderboardEntry(rank: 8, playerName: 'HoneyPaws', avatarEmoji: '🐻', score: 9310, solveTime: '1:24', countryCode: 'SG'),
    const LeaderboardEntry(rank: 18, playerName: 'You (MossyFox)', avatarEmoji: '🦔', score: 9120, solveTime: '1:35', isCurrentUser: true, countryCode: 'TH'),
  ];
}
