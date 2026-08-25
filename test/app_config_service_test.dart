import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/api/api_client.dart';
import 'package:critter_camp/services/config/app_config_service.dart';
import 'package:critter_camp/services/ads/ads_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppConfigService & AdsService Tests', () {
    late LocalStorage storage;
    late ApiClient apiClient;
    late AppConfigService configService;
    late AdsService adsService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      apiClient = ApiClient(storage: storage);
      configService = AppConfigService(storage: storage, apiClient: apiClient);
      adsService = AdsService(configService: configService);
    });

    test('Initializes with safe default config and loads cached config', () {
      expect(configService.config.appId, 'critter-camp');
      expect(configService.adsEnabled, isTrue);
      expect(configService.config.androidBannerId.isNotEmpty, isTrue);
    });

    test('Fetches remote config from Admin API and caches to local storage', () async {
      await configService.fetchRemoteConfig();
      expect(configService.config.appId, 'critter-camp');
      expect(storage.getCachedAppConfig(), isNotNull);
    });

    test('AdsService initializes and executes rewarded ad callback safely', () async {
      await adsService.initialize();
      expect(adsService.isInitialized, isTrue);

      bool rewardGranted = false;
      final shown = await adsService.showRewarded(
        onRewarded: () => rewardGranted = true,
      );

      expect(shown, isTrue);
      expect(rewardGranted, isTrue);
    });
  });
}
