import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/api/api_client.dart';
import 'package:critter_camp/services/identity/player_identity_service.dart';
import 'package:critter_camp/services/sync/cloud_sync_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CloudSyncService & Local-First Tests', () {
    late LocalStorage storage;
    late ApiClient apiClient;
    late PlayerIdentityService identityService;
    late CloudSyncService syncService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      apiClient = ApiClient(storage: storage);
      identityService = PlayerIdentityService(storage: storage, apiClient: apiClient);
      syncService = CloudSyncService(
        storage: storage,
        apiClient: apiClient,
        identityService: identityService,
      );
    });

    test('Local-First Save writes to storage immediately and queues pending sync', () async {
      await syncService.saveStageProgressLocallyFirst(
        stageNumber: 1,
        stars: 3,
        movesCount: 4,
        elapsedSeconds: 45,
        acornsReward: 15,
      );

      // Verify local storage is immediately updated
      expect(storage.getCompletedLevels().contains('1'), isTrue);
      expect(storage.getStars(), 3);
      expect(storage.getAcorns(), 65); // 50 initial + 15

      // Verify pending sync queue has the item
      final queue = storage.getPendingSyncQueue();
      expect(queue.isNotEmpty, isTrue);
      expect(queue.first['stageNumber'], 1);
    });

    test('Sync Pending Progress pushes to cloud and clears pending queue', () async {
      await syncService.saveStageProgressLocallyFirst(
        stageNumber: 2,
        stars: 3,
        movesCount: 6,
        elapsedSeconds: 60,
        acornsReward: 15,
      );

      final success = await syncService.syncPendingProgress();
      expect(success, isTrue);
      expect(syncService.status, SyncStatus.synced);
      expect(storage.getPendingSyncQueue(), isEmpty);
      expect(syncService.lastSyncedAt, isNotNull);
    });

    test('Cloud Restore merges completed stages safely into local storage', () async {
      final success = await syncService.restoreFromCloud();
      expect(success, isTrue);
      expect(syncService.status, SyncStatus.synced);
    });
  });
}
