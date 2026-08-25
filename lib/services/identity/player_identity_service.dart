import 'package:flutter/foundation.dart';
import '../../core/storage/local_storage.dart';
import '../api/api_client.dart';

class PlayerIdentity {
  final String id;
  final String guestId;
  final String? userId;
  final String? email;
  final String displayName;
  final bool isGuest;

  const PlayerIdentity({
    required this.id,
    required this.guestId,
    this.userId,
    this.email,
    required this.displayName,
    required this.isGuest,
  });

  String get effectiveId => userId ?? guestId;
}

class PlayerIdentityService extends ChangeNotifier {
  final LocalStorage storage;
  final ApiClient apiClient;

  late PlayerIdentity _currentIdentity;

  PlayerIdentityService({
    required this.storage,
    required this.apiClient,
  }) {
    _loadIdentity();
  }

  PlayerIdentity get currentIdentity => _currentIdentity;
  bool get isGuest => _currentIdentity.isGuest;
  String get effectivePlayerId => _currentIdentity.effectiveId;

  void _loadIdentity() {
    final guestId = storage.getGuestId();
    final userId = storage.getUserId();
    final email = storage.getUserEmail();
    final isGuest = storage.getIsGuest();
    final name = storage.getUsername();

    _currentIdentity = PlayerIdentity(
      id: userId ?? guestId,
      guestId: guestId,
      userId: userId,
      email: email,
      displayName: name,
      isGuest: isGuest,
    );
  }

  /// Upgrades a Guest player into an Authenticated Account without losing any progress!
  Future<bool> connectAccount({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    try {
      final guestId = _currentIdentity.guestId;

      // 1. Call Backend to merge guest progress with account
      final res = await apiClient.syncPlayerIdentity(
        guestId: guestId,
        userId: userId,
        email: email,
        displayName: displayName,
      );

      if (res.success) {
        // 2. Persist connected identity locally
        await storage.setUserId(userId);
        await storage.setUserEmail(email);
        await storage.setUsername(displayName);
        await storage.setIsGuest(false);

        _currentIdentity = PlayerIdentity(
          id: userId,
          guestId: guestId,
          userId: userId,
          email: email,
          displayName: displayName,
          isGuest: false,
        );

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[PlayerIdentityService] connectAccount error: $e');
      return false;
    }
  }

  /// Disconnects account, reverting back to persistent device Guest without wiping local progress.
  Future<void> disconnectAccount() async {
    await storage.setUserId(null);
    await storage.setUserEmail(null);
    await storage.setIsGuest(true);

    _currentIdentity = PlayerIdentity(
      id: _currentIdentity.guestId,
      guestId: _currentIdentity.guestId,
      userId: null,
      email: null,
      displayName: 'CozyCamper',
      isGuest: true,
    );

    notifyListeners();
  }

  Future<void> ensureGuestIdentity() async {
    _loadIdentity();
    notifyListeners();
  }

  Future<bool> upgradeToAccount({required String email, required String username}) async {
    return connectAccount(
      userId: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: username,
    );
  }
}
