import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../core/storage/local_storage.dart';
import '../api/api_client.dart';

class MonetizationConfig {
  final bool enabled;
  final bool rewardedHintEnabled;
  final bool rewardedPostStageBonusEnabled;
  final bool interstitialEnabled;
  final int interstitialStageInterval;
  final int interstitialCooldownSeconds;
  final int interstitialMinimumStageBeforeFirstAd;
  final int interstitialRewardedGracePeriodSeconds;
  final bool firstHintFree;
  final int maxHintsPerStage;

  const MonetizationConfig({
    this.enabled = true,
    this.rewardedHintEnabled = true,
    this.rewardedPostStageBonusEnabled = true,
    this.interstitialEnabled = true,
    this.interstitialStageInterval = 3,
    this.interstitialCooldownSeconds = 180,
    this.interstitialMinimumStageBeforeFirstAd = 4,
    this.interstitialRewardedGracePeriodSeconds = 90,
    this.firstHintFree = true,
    this.maxHintsPerStage = 3,
  });

  factory MonetizationConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MonetizationConfig();

    final rewarded = json['rewarded'] as Map<String, dynamic>? ?? {};
    final interstitial = json['interstitial'] as Map<String, dynamic>? ?? {};
    final hints = json['hints'] as Map<String, dynamic>? ?? {};

    return MonetizationConfig(
      enabled: json['enabled'] ?? true,
      rewardedHintEnabled: rewarded['hintEnabled'] ?? true,
      rewardedPostStageBonusEnabled: rewarded['postStageBonusEnabled'] ?? true,
      interstitialEnabled: interstitial['enabled'] ?? true,
      interstitialStageInterval: interstitial['stageInterval'] ?? 3,
      interstitialCooldownSeconds: interstitial['cooldownSeconds'] ?? 180,
      interstitialMinimumStageBeforeFirstAd: interstitial['minimumStageBeforeFirstAd'] ?? 4,
      interstitialRewardedGracePeriodSeconds: interstitial['rewardedGracePeriodSeconds'] ?? 90,
      firstHintFree: hints['firstHintFree'] ?? true,
      maxHintsPerStage: hints['maxHintsPerStage'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'rewarded': {
        'hintEnabled': rewardedHintEnabled,
        'postStageBonusEnabled': rewardedPostStageBonusEnabled,
      },
      'interstitial': {
        'enabled': interstitialEnabled,
        'stageInterval': interstitialStageInterval,
        'cooldownSeconds': interstitialCooldownSeconds,
        'minimumStageBeforeFirstAd': interstitialMinimumStageBeforeFirstAd,
        'rewardedGracePeriodSeconds': interstitialRewardedGracePeriodSeconds,
      },
      'hints': {
        'firstHintFree': firstHintFree,
        'maxHintsPerStage': maxHintsPerStage,
      },
    };
  }
}

class RemoteAppConfig {
  final String appId;
  final String appName;
  final bool adsEnabled;
  final String androidBannerId;
  final String androidInterstitialId;
  final String androidRewardedId;
  final String iosBannerId;
  final String iosInterstitialId;
  final String iosRewardedId;
  final MonetizationConfig monetization;
  final bool maintenanceMode;
  final String minVersion;
  final String updatedAt;

  const RemoteAppConfig({
    this.appId = 'critter-camp',
    this.appName = 'Critter Camp',
    this.adsEnabled = true,
    this.androidBannerId = 'ca-app-pub-3940256099942544/6300978111',
    this.androidInterstitialId = 'ca-app-pub-3940256099942544/1033173712',
    this.androidRewardedId = 'ca-app-pub-3940256099942544/5224354917',
    this.iosBannerId = 'ca-app-pub-3940256099942544/2934735716',
    this.iosInterstitialId = 'ca-app-pub-3940256099942544/4411468910',
    this.iosRewardedId = 'ca-app-pub-3940256099942544/1712485313',
    this.monetization = const MonetizationConfig(),
    this.maintenanceMode = false,
    this.minVersion = '1.0.0',
    this.updatedAt = '',
  });

  factory RemoteAppConfig.fromJson(Map<String, dynamic> json) {
    final ads = json['ads'] as Map<String, dynamic>? ?? {};
    final androidAds = ads['android'] as Map<String, dynamic>? ?? {};
    final iosAds = ads['ios'] as Map<String, dynamic>? ?? {};

    return RemoteAppConfig(
      appId: json['appId'] ?? 'critter-camp',
      appName: json['appName'] ?? 'Critter Camp',
      adsEnabled: json['adsEnabled'] ?? true,
      androidBannerId: androidAds['bannerId'] ?? json['android_banner_id'] ?? 'ca-app-pub-3940256099942544/6300978111',
      androidInterstitialId: androidAds['interstitialId'] ?? json['android_interstitial_id'] ?? 'ca-app-pub-3940256099942544/1033173712',
      androidRewardedId: androidAds['rewardedId'] ?? json['android_rewarded_id'] ?? 'ca-app-pub-3940256099942544/5224354917',
      iosBannerId: iosAds['bannerId'] ?? json['ios_banner_id'] ?? 'ca-app-pub-3940256099942544/2934735716',
      iosInterstitialId: iosAds['interstitialId'] ?? json['ios_interstitial_id'] ?? 'ca-app-pub-3940256099942544/4411468910',
      iosRewardedId: iosAds['rewardedId'] ?? json['ios_rewarded_id'] ?? 'ca-app-pub-3940256099942544/1712485313',
      monetization: MonetizationConfig.fromJson(json['monetization'] as Map<String, dynamic>?),
      maintenanceMode: json['maintenanceMode'] ?? json['maintenance_mode'] ?? false,
      minVersion: json['minVersion'] ?? json['min_version'] ?? '1.0.0',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'appName': appName,
      'adsEnabled': adsEnabled,
      'ads': {
        'android': {
          'bannerId': androidBannerId,
          'interstitialId': androidInterstitialId,
          'rewardedId': androidRewardedId,
        },
        'ios': {
          'bannerId': iosBannerId,
          'interstitialId': iosInterstitialId,
          'rewardedId': iosRewardedId,
        },
      },
      'monetization': monetization.toJson(),
      'maintenanceMode': maintenanceMode,
      'minVersion': minVersion,
      'updatedAt': updatedAt,
    };
  }

  static const RemoteAppConfig safeDefault = RemoteAppConfig();
}

class AppConfigService extends ChangeNotifier {
  final LocalStorage storage;
  final ApiClient apiClient;

  RemoteAppConfig _config = RemoteAppConfig.safeDefault;
  bool _isFetching = false;

  AppConfigService({
    required this.storage,
    required this.apiClient,
  }) {
    _loadCachedConfig();
  }

  RemoteAppConfig get config => _config;
  bool get adsEnabled => _config.adsEnabled && _config.monetization.enabled;
  MonetizationConfig get monetization => _config.monetization;

  void _loadCachedConfig() {
    final cached = storage.getCachedAppConfig();
    if (cached != null && cached.isNotEmpty) {
      try {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        _config = RemoteAppConfig.fromJson(map);
      } catch (e) {
        _config = RemoteAppConfig.safeDefault;
      }
    }
  }

  Future<void> fetchRemoteConfig() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final res = await apiClient.getAppConfig('critter-camp');
      if (res.success && res.data != null) {
        _config = RemoteAppConfig.fromJson(res.data!);
        await storage.setCachedAppConfig(jsonEncode(_config.toJson()));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[AppConfigService] fetchRemoteConfig failed, using cache: $e');
    } finally {
      _isFetching = false;
    }
  }
}
