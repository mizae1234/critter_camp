class PlayerBadge {
  final String id;
  final String title;
  final String iconEmoji;
  final String description;
  final bool isUnlocked;

  const PlayerBadge({
    required this.id,
    required this.title,
    required this.iconEmoji,
    required this.description,
    this.isUnlocked = true,
  });
}

class PlayerProfile {
  final String username;
  final String camperId;
  final String rankTitle;
  final int level;
  final int puzzlesSolved;
  final int perfectClears;
  final int streakDays;
  final int totalAcorns;
  final String avatarEmoji;
  final bool isLoggedIn;
  final List<PlayerBadge> badges;

  const PlayerProfile({
    required this.username,
    required this.camperId,
    required this.rankTitle,
    required this.level,
    required this.puzzlesSolved,
    required this.perfectClears,
    required this.streakDays,
    required this.totalAcorns,
    required this.avatarEmoji,
    this.isLoggedIn = true,
    this.badges = const [],
  });
}
