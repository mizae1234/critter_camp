import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/api/api_client.dart';
import 'package:critter_camp/services/config/app_config_service.dart';
import 'package:critter_camp/services/hints/progressive_hint_service.dart';
import 'package:critter_camp/game/stage/stages/stage_catalog.dart';
import 'package:critter_camp/game/stage/game_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProgressiveHintService & Multi-Solution Clues Tests', () {
    late LocalStorage storage;
    late ApiClient apiClient;
    late AppConfigService configService;
    late ProgressiveHintService hintService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      apiClient = ApiClient(storage: storage);
      configService = AppConfigService(storage: storage, apiClient: apiClient);
      hintService = ProgressiveHintService(configService: configService);
    });

    test('Tier 1 Hint gives Observation Clue and is FREE on first hint', () {
      final stage = StageCatalog.stage1;
      final state = GameState.empty(4);

      final clue = hintService.generateClue(
        stage: stage,
        state: state,
        hintsUsedOnStage: 0,
      );

      expect(clue.tier, HintTier.observation);
      expect(clue.isFree, isTrue);
      expect(clue.title.isNotEmpty, isTrue);
      expect(clue.message.isNotEmpty, isTrue);
    });

    test('Tier 2 Hint gives Constraint Deduction Clue and requires Rewarded Ad', () {
      final stage = StageCatalog.stage1;
      final state = GameState.empty(4);

      final clue = hintService.generateClue(
        stage: stage,
        state: state,
        hintsUsedOnStage: 1,
      );

      expect(clue.tier, HintTier.constraint);
      expect(clue.isFree, isFalse);
      expect(clue.message.contains('8 directions'), isTrue);
    });

    test('Tier 3 Hint gives Dynamic Placement Guidance without pre-stored answers', () {
      final stage = StageCatalog.stage5; // 6x6 Multi-Solution stage
      final state = GameState.empty(6);

      final clue = hintService.generateClue(
        stage: stage,
        state: state,
        hintsUsedOnStage: 2,
      );

      expect(clue.tier, HintTier.guidance);
      expect(clue.isFree, isFalse);
      expect(clue.suggestedRow, isNotNull);
      expect(clue.suggestedCol, isNotNull);
    });
  });
}
