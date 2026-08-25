import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String keyCurrentLevel = 'cc_current_level';
  static const String keyCompletedLevels = 'cc_completed_levels';
  static const String keyStars = 'cc_stars';
  static const String keyAcorns = 'cc_acorns';
  static const String keyStreakDays = 'cc_streak_days';
  static const String keyUnlockedCritters = 'cc_unlocked_critters';
  static const String keyZenMode = 'cc_zen_mode';
  static const String keyPatternMode = 'cc_pattern_mode';
  static const String keyMusicVolume = 'cc_music_volume';
  static const String keySfxVolume = 'cc_sfx_volume';
  static const String keyUsername = 'cc_username';

  static LocalStorage? _instance;
  late SharedPreferences _prefs;

  LocalStorage._();

  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorage._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Progress Getters & Setters
  int getCurrentLevel() => _prefs.getInt(keyCurrentLevel) ?? 18; // Default level 18
  Future<void> setCurrentLevel(int lvl) => _prefs.setInt(keyCurrentLevel, lvl);

  List<String> getCompletedLevels() =>
      _prefs.getStringList(keyCompletedLevels) ?? ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17'];
  Future<void> markLevelCompleted(int lvl) async {
    final list = getCompletedLevels();
    if (!list.contains('$lvl')) {
      list.add('$lvl');
      await _prefs.setStringList(keyCompletedLevels, list);
    }
  }

  int getStars() => _prefs.getInt(keyStars) ?? 48;
  Future<void> addStars(int amount) => _prefs.setInt(keyStars, getStars() + amount);

  int getAcorns() => _prefs.getInt(keyAcorns) ?? 1420;
  Future<void> addAcorns(int amount) => _prefs.setInt(keyAcorns, getAcorns() + amount);

  int getStreakDays() => _prefs.getInt(keyStreakDays) ?? 14;

  List<String> getUnlockedCritters() =>
      _prefs.getStringList(keyUnlockedCritters) ?? ['hazel', 'finn', 'pip', 'moss'];
  Future<void> unlockCritter(String critterId) async {
    final list = getUnlockedCritters();
    if (!list.contains(critterId)) {
      list.add(critterId);
      await _prefs.setStringList(keyUnlockedCritters, list);
    }
  }

  // Settings
  bool getZenMode() => _prefs.getBool(keyZenMode) ?? false;
  Future<void> setZenMode(bool val) => _prefs.setBool(keyZenMode, val);

  bool getPatternMode() => _prefs.getBool(keyPatternMode) ?? false;
  Future<void> setPatternMode(bool val) => _prefs.setBool(keyPatternMode, val);

  double getMusicVolume() => _prefs.getDouble(keyMusicVolume) ?? 0.8;
  Future<void> setMusicVolume(double val) => _prefs.setDouble(keyMusicVolume, val);

  double getSfxVolume() => _prefs.getDouble(keySfxVolume) ?? 1.0;
  Future<void> setSfxVolume(double val) => _prefs.setDouble(keySfxVolume, val);

  String getUsername() => _prefs.getString(keyUsername) ?? 'MossyFox';
  Future<void> setUsername(String name) => _prefs.setString(keyUsername, name);
}
