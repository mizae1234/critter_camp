import 'package:flutter/foundation.dart';
import '../../core/storage/local_storage.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
}

class ApiClient {
  final String baseUrl;
  final LocalStorage storage;

  ApiClient({
    this.baseUrl = 'http://localhost:8097/api/v1',
    required this.storage,
  });

  /// Remote App & Ads Config endpoint
  Future<ApiResponse<Map<String, dynamic>>> getAppConfig(String appId) async {
    try {
      final mockData = {
        'appId': appId,
        'appName': 'Critter Camp',
        'adsEnabled': true,
        'ads': {
          'android': {
            'appId': 'ca-app-pub-3940256099942544~3347511713',
            'bannerId': 'ca-app-pub-3940256099942544/6300978111',
            'interstitialId': 'ca-app-pub-3940256099942544/1033173712',
            'rewardedId': 'ca-app-pub-3940256099942544/5224354917',
          },
          'ios': {
            'appId': 'ca-app-pub-3940256099942544~1458002511',
            'bannerId': 'ca-app-pub-3940256099942544/2934735716',
            'interstitialId': 'ca-app-pub-3940256099942544/4411468910',
            'rewardedId': 'ca-app-pub-3940256099942544/1712485313',
          },
        },
        'featureFlags': {
          'zenModeEnabled': true,
          'patternModeEnabled': true,
          'cloudSyncEnabled': true,
        },
        'maintenanceMode': false,
        'minVersion': '1.0.0',
        'updatedAt': DateTime.now().toIso8601String(),
      };

      return ApiResponse(success: true, data: mockData);
    } catch (e) {
      debugPrint('[ApiClient] getAppConfig error: $e');
      return ApiResponse(success: false, message: e.toString());
    }
  }

  /// Player Identity endpoint
  Future<ApiResponse<Map<String, dynamic>>> syncPlayerIdentity({
    required String guestId,
    String? userId,
    String? email,
    String? displayName,
  }) async {
    try {
      final data = {
        'id': userId != null ? 'usr_$userId' : 'gst_$guestId',
        'guestId': guestId,
        'userId': userId,
        'email': email,
        'displayName': displayName ?? 'MossyFox',
        'isGuest': userId == null,
        'totalAcorns': storage.getAcorns(),
        'streakDays': storage.getStreakDays(),
      };
      return ApiResponse(success: true, data: data);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  /// Cloud Sync Push endpoint
  Future<ApiResponse<Map<String, dynamic>>> pushStageProgress({
    required String playerId,
    required List<Map<String, dynamic>> stages,
  }) async {
    try {
      return ApiResponse(
        success: true,
        data: {
          'playerId': playerId,
          'syncedCount': stages.length,
          'stages': stages,
          'syncedAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  /// Cloud Sync Pull endpoint
  Future<ApiResponse<List<Map<String, dynamic>>>> pullStageProgress(String playerId) async {
    try {
      final localCompleted = storage.getCompletedLevels();
      final List<Map<String, dynamic>> list = localCompleted.map((lvl) {
        return {
          'stageNumber': int.tryParse(lvl) ?? 1,
          'completed': true,
          'stars': 3,
        };
      }).toList();

      return ApiResponse(success: true, data: list);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
