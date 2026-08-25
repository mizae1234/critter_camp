import '../models/player_profile.dart';

class MockPlayerData {
  static final PlayerProfile defaultProfile = PlayerProfile(
    username: 'MossyFox',
    camperId: '#8842',
    rankTitle: 'Forest Master',
    level: 18,
    puzzlesSolved: 142,
    perfectClears: 128,
    streakDays: 14,
    totalAcorns: 1420,
    avatarEmoji: '🦊',
    isLoggedIn: true,
    badges: const [
      PlayerBadge(id: '1', title: 'Early Camper', iconEmoji: '🏕️', description: 'Joined during Camp Beta'),
      PlayerBadge(id: '2', title: 'Perfectionist', iconEmoji: '⭐', description: '100+ Perfect Clears with no wrong moves'),
      PlayerBadge(id: '3', title: 'Forest Whisperer', iconEmoji: '🌲', description: 'Cleared Forest Trail biome'),
      PlayerBadge(id: '4', title: 'Critter Friend', iconEmoji: '🦔', description: 'Befriended 5+ unique critters'),
    ],
  );
}
