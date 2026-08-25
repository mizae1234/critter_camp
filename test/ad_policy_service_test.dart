import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/api/api_client.dart';
import 'package:critter_camp/services/config/app_config_service.dart';
import 'package:critter_camp/services/ads/ads_service.dart';
import 'package:critter_camp/services/ads/ad_policy_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdPolicyService & Interstitial Frequency Guardrails Tests', () {
    late LocalStorage storage;
    late ApiClient apiClient;
    late AppConfigService configService;
    late AdsService adsService;
    late AdPolicyService policyService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      apiClient = ApiClient(storage: storage);
      configService = AppConfigService(storage: storage, apiClient: apiClient);
      adsService = AdsService(configService: configService);
      policyService = AdPolicyService(configService: configService, adsService: adsService);
    });

    test('Early stages (Stages 1 to 3) never show Interstitials for new player protection', () {
      expect(policyService.canShowInterstitial(stageNumber: 1), isFalse);
      expect(policyService.canShowInterstitial(stageNumber: 2), isFalse);
      expect(policyService.canShowInterstitial(stageNumber: 3), isFalse);
    });

    test('Stage 4 (Interval reached & >= min stage) allows Interstitial', () {
      policyService.recordStageCompleted();
      policyService.recordStageCompleted();
      policyService.recordStageCompleted();
      expect(policyService.canShowInterstitial(stageNumber: 4), isTrue);
    });

    test('Displaying Interstitial activates cooldown timer', () {
      policyService.recordInterstitialShown();
      // Immediately after, cooldown blocks subsequent interstitial
      expect(policyService.canShowInterstitial(stageNumber: 6), isFalse);
    });

    test('Completing a Rewarded Ad activates grace period protection', () {
      policyService.recordRewardedCompleted();
      // Grace period blocks interstitial even if stage interval reached
      expect(policyService.canShowInterstitial(stageNumber: 6), isFalse);
    });

    test('Rewarded Hint and Post-Stage Bonus eligibility rules', () {
      expect(policyService.canOfferRewardedHint(hintsUsedOnStage: 0), isTrue);
      expect(policyService.canOfferRewardedHint(hintsUsedOnStage: 2), isTrue);
      expect(policyService.canOfferRewardedHint(hintsUsedOnStage: 3), isFalse);
      expect(policyService.canOfferPostStageBonus(), isTrue);
    });
  });
}
