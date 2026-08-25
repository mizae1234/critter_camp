import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Progress Keys
  static const String keyCurrentLevel = 'cc_current_level';
  static const String keyCompletedLevels = 'cc_completed_levels';
  static const String keyStars = 'cc_stars';
  static const String keyAcorns = 'cc_acorns';
  static const String keyStreakDays = 'cc_streak_days';
  static const String keyUnlockedCritters = 'cc_unlocked_critters';
  
  // Settings Keys
  static const String keyZenMode = 'cc_zen_mode';
  static const String keyPatternMode = 'cc_pattern_mode';
  static const String keyMusicVolume = 'cc_music_volume';
  static const String keySfxVolume = 'cc_sfx_volume';
  static const String keyUsername = 'cc_username';

  // Identity & Cloud Sync Keys
  static const String keyGuestId = 'cc_guest_id';
  static const String keyUserId = 'cc_user_id';
  static const String keyUserEmail = 'cc_user_email';
  static const String keyIsGuest = 'cc_is_guest';
  static const String keyAuthToken = 'cc_auth_token';
  static const String keyLastSyncTime = 'cc_last_sync_time';
  static const String keyPendingSyncQueue = 'cc_pending_sync_queue';
  static const String keyCachedAppConfig = 'cc_cached_app_config';
  static const String keyHasSeenOnboarding = 'cc_has_seen_onboarding';
  static const String keyLanguage = 'cc_language';

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

  // ==================== IDENTITY ====================

  /// Gets or generates a persistent Guest UUID for this device.
  String getGuestId() {
    String? id = _prefs.getString(keyGuestId);
    if (id == null || id.isEmpty) {
      id = 'guest_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000))}';
      _prefs.setString(keyGuestId, id);
    }
    return id;
  }

  String? getUserId() => _prefs.getString(keyUserId);
  Future<void> setUserId(String? userId) async {
    if (userId == null) {
      await _prefs.remove(keyUserId);
    } else {
      await _prefs.setString(keyUserId, userId);
    }
  }

  String? getUserEmail() => _prefs.getString(keyUserEmail);
  Future<void> setUserEmail(String? email) async {
    if (email == null) {
      await _prefs.remove(keyUserEmail);
    } else {
      await _prefs.setString(keyUserEmail, email);
    }
  }

  bool getIsGuest() => _prefs.getBool(keyIsGuest) ?? true;
  Future<void> setIsGuest(bool isGuest) => _prefs.setBool(keyIsGuest, isGuest);

  // ==================== PROGRESS ====================

  int getCurrentLevel() => _prefs.getInt(keyCurrentLevel) ?? 1;
  Future<void> setCurrentLevel(int lvl) => _prefs.setInt(keyCurrentLevel, lvl);

  List<String> getCompletedLevels() =>
      _prefs.getStringList(keyCompletedLevels) ?? [];
      
  Future<void> markLevelCompleted(int lvl) async {
    final list = getCompletedLevels();
    if (!list.contains('$lvl')) {
      list.add('$lvl');
      await _prefs.setStringList(keyCompletedLevels, list);
    }
  }

  int getStars() => _prefs.getInt(keyStars) ?? 0;
  Future<void> addStars(int amount) => _prefs.setInt(keyStars, getStars() + amount);
  Future<void> setStars(int total) => _prefs.setInt(keyStars, total);

  int getAcorns() => _prefs.getInt(keyAcorns) ?? 50;
  Future<void> addAcorns(int amount) => _prefs.setInt(keyAcorns, getAcorns() + amount);
  Future<void> setAcorns(int total) => _prefs.setInt(keyAcorns, total);

  int getStreakDays() => _prefs.getInt(keyStreakDays) ?? 1;

  List<String> getUnlockedCritters() =>
      _prefs.getStringList(keyUnlockedCritters) ?? ['hazel'];
      
  Future<void> unlockCritter(String critterId) async {
    final list = getUnlockedCritters();
    if (!list.contains(critterId)) {
      list.add(critterId);
      await _prefs.setStringList(keyUnlockedCritters, list);
    }
  }

  // ==================== SETTINGS ====================

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

  // ==================== CLOUD SYNC & CACHING ====================

  String? getLastSyncTime() => _prefs.getString(keyLastSyncTime);
  Future<void> setLastSyncTime(String isoString) =>
      _prefs.setString(keyLastSyncTime, isoString);

  List<Map<String, dynamic>> getPendingSyncQueue() {
    final raw = _prefs.getString(keyPendingSyncQueue);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> enqueuePendingSync(Map<String, dynamic> stageProgress) async {
    final queue = getPendingSyncQueue();
    // Replace or add
    queue.removeWhere((item) => item['stageNumber'] == stageProgress['stageNumber']);
    queue.add(stageProgress);
    await _prefs.setString(keyPendingSyncQueue, jsonEncode(queue));
  }

  Future<void> clearPendingSyncQueue() async {
    await _prefs.remove(keyPendingSyncQueue);
  }

  String? getCachedAppConfig() => _prefs.getString(keyCachedAppConfig);
  Future<void> setCachedAppConfig(String jsonString) =>
      _prefs.setString(keyCachedAppConfig, jsonString);

  bool getHasSeenOnboarding() => _prefs.getBool(keyHasSeenOnboarding) ?? false;
  Future<void> setHasSeenOnboarding(bool val) => _prefs.setBool(keyHasSeenOnboarding, val);

  String getLanguage() => _prefs.getString(keyLanguage) ?? 'th';
  Future<void> setLanguage(String lang) => _prefs.setString(keyLanguage, lang);
}
