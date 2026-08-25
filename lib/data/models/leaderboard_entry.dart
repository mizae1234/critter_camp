class LeaderboardEntry {
  final int rank;
  final String playerName;
  final String avatarEmoji;
  final int score;
  final String solveTime;
  final bool isCurrentUser;
  final String countryCode;

  const LeaderboardEntry({
    required this.rank,
    required this.playerName,
    required this.avatarEmoji,
    required this.score,
    required this.solveTime,
    this.isCurrentUser = false,
    this.countryCode = 'TH',
  });
}
