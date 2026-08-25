import 'package:flutter/foundation.dart';

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  const AnalyticsEvent({
    required this.name,
    required this.parameters,
    required this.timestamp,
  });

  @override
  String toString() => 'AnalyticsEvent($name, $parameters)';
}

class AnalyticsService extends ChangeNotifier {
  final List<AnalyticsEvent> _eventLog = [];
  final Set<String> _processedGrantIds = {};

  List<AnalyticsEvent> get eventLog => List.unmodifiable(_eventLog);

  void track(String name, [Map<String, dynamic> parameters = const {}]) {
    final event = AnalyticsEvent(
      name: name,
      parameters: parameters,
      timestamp: DateTime.now(),
    );
    _eventLog.add(event);
    debugPrint('[Analytics] $name: $parameters');
    notifyListeners();
  }

  // ==================== GAMEPLAY EVENTS ====================

  void trackGameStarted() {
    track('game_started');
  }

  void trackStageStarted({required int stageNumber, required String stageName}) {
    track('stage_started', {
      'stage_number': stageNumber,
      'stage_name': stageName,
    });
  }

  void trackStageRestarted({required int stageNumber}) {
    track('stage_restarted', {
      'stage_number': stageNumber,
    });
  }

  void trackStageCompleted({
    required int stageNumber,
    required int stars,
    required int moves,
    required int elapsedSeconds,
    required int hintsUsed,
  }) {
    track('stage_completed', {
      'stage_number': stageNumber,
      'stars': stars,
      'moves_count': moves,
      'elapsed_seconds': elapsedSeconds,
      'hints_used': hintsUsed,
    });
  }

  void trackStageAbandoned({required int stageNumber, String reason = 'user_exit'}) {
    track('stage_abandoned', {
      'stage_number': stageNumber,
      'reason': reason,
    });
  }

  void trackHintRequested({required int stageNumber, required int hintTier, required bool isFree}) {
    track('hint_requested', {
      'stage_number': stageNumber,
      'hint_tier': hintTier,
      'is_free': isFree,
    });
  }

  void trackHintUsed({required int stageNumber, required String hintTier}) {
    track('hint_used', {
      'stage_number': stageNumber,
      'hint_tier': hintTier,
    });
  }

  // ==================== AD TELEMETRY EVENTS ====================

  void trackRewardedOffered({required String placement}) {
    track('rewarded_ad_offered', {'placement': placement});
  }

  void trackRewardedStarted({required String placement}) {
    track('rewarded_ad_started', {'placement': placement});
  }

  void trackRewardedCompleted({required String placement}) {
    track('rewarded_ad_completed', {'placement': placement});
  }

  void trackRewardedFailed({required String placement, required String error}) {
    track('rewarded_ad_failed', {
      'placement': placement,
      'error': error,
    });
  }

  bool trackRewardGranted({required String grantId, required String rewardType, required int amount}) {
    // Deduplication protection
    if (_processedGrantIds.contains(grantId)) {
      debugPrint('[Analytics] Duplicate reward grant rejected: $grantId');
      return false;
    }
    _processedGrantIds.add(grantId);
    track('reward_granted', {
      'grant_id': grantId,
      'reward_type': rewardType,
      'amount': amount,
    });
    return true;
  }

  void trackInterstitialEligible({required int stageNumber}) {
    track('interstitial_eligible', {'stage_number': stageNumber});
  }

  void trackInterstitialShown({required int stageNumber}) {
    track('interstitial_shown', {'stage_number': stageNumber});
  }

  void trackInterstitialFailed({required int stageNumber, required String error}) {
    track('interstitial_failed', {
      'stage_number': stageNumber,
      'error': error,
    });
  }
}
