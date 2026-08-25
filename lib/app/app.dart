import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import '../core/storage/local_storage.dart';
import '../core/widgets/critter_bottom_nav.dart';
import '../data/models/critter_model.dart';
import '../data/models/user_progress.dart';
import '../data/repositories/collection_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/leaderboard_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../services/api/api_client.dart';
import '../services/config/app_config_service.dart';
import '../services/ads/ads_service.dart';
import '../services/ads/ad_policy_service.dart';
import '../services/hints/progressive_hint_service.dart';
import '../services/analytics/analytics_service.dart';
import '../services/identity/player_identity_service.dart';
import '../services/sync/cloud_sync_service.dart';
import '../game/stage/stage_definition.dart';
import '../game/stage/stages/stage_catalog.dart';
import '../game/validator/stage_validation_result.dart';
import '../features/onboarding/presentation/first_launch_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/journey/presentation/journey_screen.dart';
import '../features/gameplay/presentation/gameplay_screen.dart';
import '../features/gameplay/presentation/level_complete_screen.dart';
import '../features/collection/presentation/collection_screen.dart';
import '../features/daily/presentation/daily_challenge_screen.dart';
import '../features/tutorial/presentation/tutorial_screen.dart';
import '../features/leaderboard/presentation/leaderboard_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

enum AppView {
  firstLaunch,
  mainTabs,
  gameplay,
  levelComplete,
  tutorial,
  settings,
  leaderboard,
}

class CritterCampApp extends StatefulWidget {
  final LocalStorage storage;

  const CritterCampApp({super.key, required this.storage});

  @override
  State<CritterCampApp> createState() => _CritterCampAppState();
}

class _CritterCampAppState extends State<CritterCampApp> {
  // Services
  late ApiClient _apiClient;
  late AppConfigService _configService;
  late AdsService _adsService;
  late AdPolicyService _adPolicyService;
  late ProgressiveHintService _hintService;
  late AnalyticsService _analyticsService;
  late PlayerIdentityService _identityService;
  late CloudSyncService _syncService;

  // Repositories
  late ProgressRepository _progressRepo;
  late CollectionRepository _collectionRepo;
  late LeaderboardRepository _leaderboardRepo;
  late AuthRepository _authRepo;

  AppView _currentView = AppView.mainTabs;
  CritterNavTab _currentTab = CritterNavTab.home;
  StageDefinition _activeStage = StageCatalog.stage1;
  StageValidationResult _lastValidationResult = StageValidationResult.initial;
  
  UserProgress _userProgress = const UserProgress(
    currentLevel: 1,
    completedLevels: [],
    totalStars: 0,
    acorns: 50,
    streakDays: 1,
  );

  List<CritterModel> _critters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 1. Initialize Services
    _apiClient = ApiClient(storage: widget.storage);
    _configService = AppConfigService(storage: widget.storage, apiClient: _apiClient);
    _adsService = AdsService(configService: _configService);
    _adPolicyService = AdPolicyService(configService: _configService, adsService: _adsService);
    _hintService = ProgressiveHintService(configService: _configService);
    _analyticsService = AnalyticsService();
    _identityService = PlayerIdentityService(storage: widget.storage, apiClient: _apiClient);
    _syncService = CloudSyncService(storage: widget.storage, apiClient: _apiClient, identityService: _identityService);

    // 2. Initialize Repositories
    _progressRepo = LocalProgressRepository(widget.storage);
    _collectionRepo = LocalCollectionRepository(widget.storage);
    _leaderboardRepo = MockLeaderboardRepository();
    _authRepo = MockAuthRepository(widget.storage);

    // 3. Track App Start & Init Background Services
    _analyticsService.trackGameStarted();
    if (!widget.storage.getHasSeenOnboarding()) {
      _currentView = AppView.firstLaunch;
    }
    _loadAppState();
    _initBackgroundServices();
  }

  Future<void> _initBackgroundServices() async {
    await _configService.fetchRemoteConfig();
    await _adsService.initialize();
    await _syncService.syncPendingProgress();
  }

  Future<void> _loadAppState() async {
    final progress = await _progressRepo.getUserProgress();
    final critters = await _collectionRepo.getCritters();
    setState(() {
      _userProgress = progress;
      _critters = critters;
      _isLoading = false;
    });
  }

  void _startStage(StageDefinition stage) {
    setState(() {
      _activeStage = stage;
      _currentView = AppView.gameplay;
    });
  }

  Future<void> _handleStageWon(StageValidationResult result) async {
    _lastValidationResult = result;
    final int starsEarned = result.starsEarned;

    // 1. Local-First Save + Asynchronous Cloud Sync
    await _syncService.saveStageProgressLocallyFirst(
      stageNumber: _activeStage.stageNumber,
      stars: starsEarned,
      movesCount: 0,
      elapsedSeconds: 75,
      acornsReward: _activeStage.baseAcornsReward,
    );

    // 2. Unlock Collection reward
    await _collectionRepo.unlockCritter(_activeStage.rewardCritterId);
    await _loadAppState();

    setState(() {
      _currentView = AppView.levelComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Critter Camp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case AppView.firstLaunch:
        return FirstLaunchScreen(
          onStartPlaying: () {
            widget.storage.setHasSeenOnboarding(true);
            setState(() => _currentView = AppView.mainTabs);
          },
          onHowToPlay: () => setState(() => _currentView = AppView.tutorial),
        );

      case AppView.tutorial:
        return TutorialScreen(
          onDismiss: () => setState(() => _currentView = AppView.mainTabs),
        );

      case AppView.settings:
        return SettingsScreen(
          storage: widget.storage,
          syncService: _syncService,
          configService: _configService,
          onBack: () => setState(() => _currentView = AppView.mainTabs),
        );

      case AppView.leaderboard:
        return Scaffold(
          appBar: AppBar(
            title: const Text('Leaderboard'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => setState(() => _currentView = AppView.mainTabs),
            ),
          ),
          body: LeaderboardScreen(repository: _leaderboardRepo),
        );

      case AppView.gameplay:
        return GameplayScreen(
          stage: _activeStage,
          hintService: _hintService,
          adsService: _adsService,
          analyticsService: _analyticsService,
          onBack: () => setState(() => _currentView = AppView.mainTabs),
          onStageCompleted: _handleStageWon,
        );

      case AppView.levelComplete:
        final unlocked = _critters.firstWhere(
          (c) => c.id == _activeStage.rewardCritterId,
          orElse: () => _critters.first,
        );
        return LevelCompleteScreen(
          stageNumber: _activeStage.stageNumber,
          stageName: _activeStage.name,
          validationResult: _lastValidationResult,
          acornsEarned: _activeStage.baseAcornsReward,
          solveTime: '1m 15s',
          unlockedCritter: unlocked,
          adPolicyService: _adPolicyService,
          adsService: _adsService,
          analyticsService: _analyticsService,
          onBonusAcornsClaimed: (extraAcorns) async {
            await widget.storage.addAcorns(extraAcorns);
            await _loadAppState();
          },
          onNextStage: () {
            final nextStage = StageCatalog.getByNumber(_activeStage.stageNumber + 1);
            _startStage(nextStage);
          },
          onReplay: () {
            _startStage(_activeStage);
          },
          onBackHome: () {
            setState(() {
              _currentView = AppView.mainTabs;
              _currentTab = CritterNavTab.home;
            });
          },
        );

      case AppView.mainTabs:
        return Scaffold(
          body: _buildTabBody(),
          bottomNavigationBar: CritterBottomNav(
            currentTab: _currentTab,
            onTabSelected: (tab) => setState(() => _currentTab = tab),
          ),
        );
    }
  }

  Widget _buildTabBody() {
    switch (_currentTab) {
      case CritterNavTab.home:
        return HomeScreen(
          userProgress: _userProgress,
          recentCritters: _critters,
          onContinueLevel: () => _startStage(StageCatalog.getByNumber(_userProgress.currentLevel)),
          onPlayDaily: () => _startStage(StageCatalog.stage5),
          onSelectCritter: (c) => setState(() => _currentTab = CritterNavTab.collection),
          onOpenSettings: () => setState(() => _currentView = AppView.settings),
        );

      case CritterNavTab.journey:
        return JourneyScreen(
          userProgress: _userProgress,
          onSelectLevel: (lvl) => _startStage(StageCatalog.getByNumber(lvl)),
        );

      case CritterNavTab.daily:
        return DailyChallengeScreen(
          onPlayDaily: () => _startStage(StageCatalog.stage5),
        );

      case CritterNavTab.collection:
        return CollectionScreen(critters: _critters);

      case CritterNavTab.profile:
        return ProfileScreen(
          authRepository: _authRepo,
          identityService: _identityService,
          syncService: _syncService,
          onOpenSettings: () => setState(() => _currentView = AppView.settings),
        );
    }
  }
}
