import 'package:flutter/foundation.dart';
import '../config/app_config_service.dart';
import 'ads_service.dart';

class AdPolicyService extends ChangeNotifier {
  final AppConfigService configService;
  final AdsService adsService;

  DateTime? _lastInterstitialTime;
  DateTime? _lastRewardedTime;
  int _completedStagesSinceLastInterstitial = 0;

  AdPolicyService({
    required this.configService,
    required this.adsService,
  });

  DateTime? get lastInterstitialTime => _lastInterstitialTime;
  DateTime? get lastRewardedTime => _lastRewardedTime;

  /// Determines whether an Interstitial Ad is strictly eligible to be shown at a natural break.
  bool canShowInterstitial({required int stageNumber}) {
    if (!adsService.adsEnabled) return false;
    final mon = configService.monetization;
    if (!mon.interstitialEnabled) return false;

    // 1. First-session / early stage protection (e.g. never before Stage 4)
    if (stageNumber < mon.interstitialMinimumStageBeforeFirstAd) {
      debugPrint('[AdPolicyService] Interstitial blocked: stage $stageNumber < min ${mon.interstitialMinimumStageBeforeFirstAd}');
      return false;
    }

    // 2. Stage frequency interval check
    if (stageNumber % mon.interstitialStageInterval != 0 && _completedStagesSinceLastInterstitial < mon.interstitialStageInterval) {
      debugPrint('[AdPolicyService] Interstitial blocked: interval not reached');
      return false;
    }

    final now = DateTime.now();

    // 3. Time-based cooldown check (e.g. 180s between interstitials)
    if (_lastInterstitialTime != null) {
      final elapsedSec = now.difference(_lastInterstitialTime!).inSeconds;
      if (elapsedSec < mon.interstitialCooldownSeconds) {
        debugPrint('[AdPolicyService] Interstitial blocked: cooldown (${elapsedSec}s < ${mon.interstitialCooldownSeconds}s)');
        return false;
      }
    }

    // 4. Rewarded -> Interstitial grace period check (e.g. 90s grace after rewarded ad)
    if (_lastRewardedTime != null) {
      final elapsedRewardedSec = now.difference(_lastRewardedTime!).inSeconds;
      if (elapsedRewardedSec < mon.interstitialRewardedGracePeriodSeconds) {
        debugPrint('[AdPolicyService] Interstitial blocked: rewarded grace period (${elapsedRewardedSec}s < ${mon.interstitialRewardedGracePeriodSeconds}s)');
        return false;
      }
    }

    return true;
  }

  /// Records an interstitial ad display
  void recordInterstitialShown() {
    _lastInterstitialTime = DateTime.now();
    _completedStagesSinceLastInterstitial = 0;
    notifyListeners();
  }

  /// Records a rewarded ad completion (starts grace period)
  void recordRewardedCompleted() {
    _lastRewardedTime = DateTime.now();
    notifyListeners();
  }

  /// Increments stage counter on stage complete
  void recordStageCompleted() {
    _completedStagesSinceLastInterstitial++;
  }

  /// Determines if a Rewarded Hint can be offered
  bool canOfferRewardedHint({required int hintsUsedOnStage}) {
    final mon = configService.monetization;
    if (!adsService.adsEnabled || !mon.rewardedHintEnabled) return false;
    return hintsUsedOnStage < mon.maxHintsPerStage;
  }

  /// Determines if a Post-Stage Bonus can be offered
  bool canOfferPostStageBonus() {
    final mon = configService.monetization;
    if (!adsService.adsEnabled) return false;
    return mon.rewardedPostStageBonusEnabled;
  }
}
