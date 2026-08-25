import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/api/api_client.dart';
import 'package:critter_camp/services/identity/player_identity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayerIdentityService & Account Upgrade Tests', () {
    late LocalStorage storage;
    late ApiClient apiClient;
    late PlayerIdentityService identityService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      apiClient = ApiClient(storage: storage);
      identityService = PlayerIdentityService(storage: storage, apiClient: apiClient);
    });

    test('Fresh install generates persistent Guest Identity', () {
      expect(identityService.isGuest, isTrue);
      expect(identityService.currentIdentity.guestId.isNotEmpty, isTrue);
      expect(identityService.effectivePlayerId.startsWith('guest_'), isTrue);

      // Verify persistence
      final savedGuestId = storage.getGuestId();
      expect(identityService.currentIdentity.guestId, savedGuestId);
    });

    test('Account Upgrade (Guest -> Account) merges progress without data loss', () async {
      // Simulate playing as guest
      await storage.markLevelCompleted(1);
      await storage.markLevelCompleted(2);
      await storage.addStars(6);
      await storage.addAcorns(30);

      expect(storage.getCompletedLevels().length, 2);

      // Connect Account
      final success = await identityService.connectAccount(
        userId: 'usr_mossy_123',
        email: 'mossy@crittercamp.com',
        displayName: 'MossyExplorer',
      );

      expect(success, isTrue);
      expect(identityService.isGuest, isFalse);
      expect(identityService.effectivePlayerId, 'usr_mossy_123');
      expect(identityService.currentIdentity.email, 'mossy@crittercamp.com');

      // Verify zero progress lost!
      expect(storage.getCompletedLevels().length, 2);
      expect(storage.getStars(), 6);
      expect(storage.getAcorns(), 80); // 50 initial + 30
    });

    test('Disconnecting account reverts to device guest safely', () async {
      await identityService.connectAccount(
        userId: 'usr_test',
        email: 'test@camp.com',
        displayName: 'Tester',
      );
      expect(identityService.isGuest, isFalse);

      await identityService.disconnectAccount();
      expect(identityService.isGuest, isTrue);
      expect(identityService.effectivePlayerId.startsWith('guest_'), isTrue);
    });
  });
}
