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
import '../game/levels/puzzle_level_catalog.dart';
import '../game/models/puzzle_board_data.dart';
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
  late ProgressRepository _progressRepo;
  late CollectionRepository _collectionRepo;
  late LeaderboardRepository _leaderboardRepo;
  late AuthRepository _authRepo;

  AppView _currentView = AppView.mainTabs;
  CritterNavTab _currentTab = CritterNavTab.home;
  PuzzleLevelData _activeLevel = PuzzleLevelCatalog.level18;
  
  UserProgress _userProgress = const UserProgress(
    currentLevel: 18,
    completedLevels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
    totalStars: 48,
    acorns: 1420,
    streakDays: 14,
  );

  List<CritterModel> _critters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _progressRepo = LocalProgressRepository(widget.storage);
    _collectionRepo = LocalCollectionRepository(widget.storage);
    _leaderboardRepo = MockLeaderboardRepository();
    _authRepo = MockAuthRepository(widget.storage);
    _loadAppState();
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

  void _startLevel(PuzzleLevelData level) {
    setState(() {
      _activeLevel = level;
      _currentView = AppView.gameplay;
    });
  }

  Future<void> _handleLevelWon() async {
    // Reward progress
    await _progressRepo.completeLevel(_activeLevel.levelNumber, 3, 15);
    await _collectionRepo.unlockCritter(_activeLevel.rewardCritterId);
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
          onStartPlaying: () => setState(() => _currentView = AppView.mainTabs),
          onHowToPlay: () => setState(() => _currentView = AppView.tutorial),
        );

      case AppView.tutorial:
        return TutorialScreen(
          onDismiss: () => setState(() => _currentView = AppView.mainTabs),
        );

      case AppView.settings:
        return SettingsScreen(
          storage: widget.storage,
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
          level: _activeLevel,
          onBack: () => setState(() => _currentView = AppView.mainTabs),
          onLevelCompleted: _handleLevelWon,
        );

      case AppView.levelComplete:
        final unlocked = _critters.firstWhere(
          (c) => c.id == _activeLevel.rewardCritterId,
          orElse: () => _critters.first,
        );
        return LevelCompleteScreen(
          levelNumber: _activeLevel.levelNumber,
          solveTime: '1m 24s',
          unlockedCritter: unlocked,
          onNextPuzzle: () {
            final nextLvl = PuzzleLevelCatalog.getByNumber(_activeLevel.levelNumber + 1);
            _startLevel(nextLvl);
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
          onContinueLevel: () => _startLevel(PuzzleLevelCatalog.getByNumber(_userProgress.currentLevel)),
          onPlayDaily: () => _startLevel(PuzzleLevelCatalog.daily7x7),
          onSelectCritter: (c) => setState(() => _currentTab = CritterNavTab.collection),
          onOpenSettings: () => setState(() => _currentView = AppView.settings),
        );

      case CritterNavTab.journey:
        return JourneyScreen(
          userProgress: _userProgress,
          onSelectLevel: (lvl) => _startLevel(PuzzleLevelCatalog.getByNumber(lvl)),
        );

      case CritterNavTab.daily:
        return DailyChallengeScreen(
          onPlayDaily: () => _startLevel(PuzzleLevelCatalog.daily7x7),
        );

      case CritterNavTab.collection:
        return CollectionScreen(critters: _critters);

      case CritterNavTab.profile:
        return ProfileScreen(
          authRepository: _authRepo,
          onOpenSettings: () => setState(() => _currentView = AppView.settings),
        );
    }
  }
}
