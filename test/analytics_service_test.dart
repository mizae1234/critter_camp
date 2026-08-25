import 'package:flutter_test/flutter_test.dart';
import 'package:critter_camp/services/analytics/analytics_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnalyticsService Telemetry & Deduplication Tests', () {
    late AnalyticsService analytics;

    setUp(() {
      analytics = AnalyticsService();
    });

    test('Tracks core gameplay events with telemetry properties', () {
      analytics.trackGameStarted();
      analytics.trackStageStarted(stageNumber: 1, stageName: 'Sunlit Meadow');
      analytics.trackHintUsed(stageNumber: 1, hintTier: 'observation');
      analytics.trackStageCompleted(
        stageNumber: 1,
        stars: 3,
        moves: 4,
        elapsedSeconds: 42,
        hintsUsed: 1,
      );

      expect(analytics.eventLog.length, 4);
      expect(analytics.eventLog[0].name, 'game_started');
      expect(analytics.eventLog[1].name, 'stage_started');
      expect(analytics.eventLog[2].name, 'hint_used');
      expect(analytics.eventLog[3].name, 'stage_completed');
      expect(analytics.eventLog[3].parameters['stars'], 3);
      expect(analytics.eventLog[3].parameters['elapsed_seconds'], 42);
    });

    test('Reward granting prevents duplicate reward calls', () {
      final firstAttempt = analytics.trackRewardGranted(
        grantId: 'reward_stage_1_post',
        rewardType: 'acorns_double',
        amount: 15,
      );

      final secondAttempt = analytics.trackRewardGranted(
        grantId: 'reward_stage_1_post',
        rewardType: 'acorns_double',
        amount: 15,
      );

      expect(firstAttempt, isTrue);
      expect(secondAttempt, isFalse); // Deduplication protected!
    });
  });
}
