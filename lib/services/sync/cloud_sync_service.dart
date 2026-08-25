import 'package:flutter/foundation.dart';
import '../../core/storage/local_storage.dart';
import '../api/api_client.dart';
import '../identity/player_identity_service.dart';

enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
}

class CloudSyncService extends ChangeNotifier {
  final LocalStorage storage;
  final ApiClient apiClient;
  final PlayerIdentityService identityService;

  SyncStatus _status = SyncStatus.idle;
  String? _lastSyncedAt;

  CloudSyncService({
    required this.storage,
    required this.apiClient,
    required this.identityService,
  }) {
    _lastSyncedAt = storage.getLastSyncTime();
  }

  SyncStatus get status => _status;
  String? get lastSyncedAt => _lastSyncedAt;
  bool get hasPendingSync => storage.getPendingSyncQueue().isNotEmpty;

  /// Saves stage progress locally first, then queues for asynchronous cloud sync.
  Future<void> saveStageProgressLocallyFirst({
    required int stageNumber,
    required int stars,
    required int movesCount,
    required int elapsedSeconds,
    required int acornsReward,
  }) async {
    // 1. Immediate Local Save
    await storage.markLevelCompleted(stageNumber);
    await storage.addStars(stars);
    await storage.addAcorns(acornsReward);

    // If next level is higher, unlock it
    if (stageNumber >= storage.getCurrentLevel()) {
      await storage.setCurrentLevel(stageNumber + 1);
    }

    // 2. Queue for background sync
    final stagePayload = {
      'stageNumber': stageNumber,
      'completed': true,
      'stars': stars,
      'bestMoves': movesCount,
      'bestTimeSeconds': elapsedSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await storage.enqueuePendingSync(stagePayload);

    // 3. Asynchronously trigger cloud sync
    syncPendingProgress();
  }

  /// Synchronizes all pending local progress to cloud with safe merge logic
  Future<bool> syncPendingProgress() async {
    final queue = storage.getPendingSyncQueue();
    if (queue.isEmpty) {
      _status = SyncStatus.synced;
      notifyListeners();
      return true;
    }

    _status = SyncStatus.syncing;
    notifyListeners();

    try {
      final playerId = identityService.effectivePlayerId;
      final res = await apiClient.pushStageProgress(
        playerId: playerId,
        stages: queue,
      );

      if (res.success) {
        await storage.clearPendingSyncQueue();
        final now = DateTime.now().toIso8601String();
        await storage.setLastSyncTime(now);
        _lastSyncedAt = now;
        _status = SyncStatus.synced;
        notifyListeners();
        return true;
      } else {
        _status = SyncStatus.offline;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('[CloudSyncService] sync failed, progress safely preserved locally: $e');
      _status = SyncStatus.offline;
      notifyListeners();
      return false;
    }
  }

  /// Restores progress from cloud and merges safely into local storage
  Future<bool> restoreFromCloud() async {
    _status = SyncStatus.syncing;
    notifyListeners();

    try {
      final playerId = identityService.effectivePlayerId;
      final res = await apiClient.pullStageProgress(playerId);

      if (res.success && res.data != null) {
        final cloudStages = res.data!;
        
        // Safe Merge into local
        for (final item in cloudStages) {
          final int stageNum = item['stageNumber'] ?? 1;
          await storage.markLevelCompleted(stageNum);
        }

        final now = DateTime.now().toIso8601String();
        await storage.setLastSyncTime(now);
        _lastSyncedAt = now;
        _status = SyncStatus.synced;
        notifyListeners();
        return true;
      }
      _status = SyncStatus.offline;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('[CloudSyncService] restore failed: $e');
      _status = SyncStatus.error;
      notifyListeners();
      return false;
    }
  }
}
