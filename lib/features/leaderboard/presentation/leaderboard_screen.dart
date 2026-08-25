import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../data/models/leaderboard_entry.dart';
import '../../../data/repositories/leaderboard_repository.dart';

class LeaderboardScreen extends StatefulWidget {
  final LeaderboardRepository repository;

  const LeaderboardScreen({super.key, required this.repository});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String _selectedTab = 'Daily';
  List<LeaderboardEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final list = await widget.repository.getLeaderboard(timeframe: _selectedTab.toLowerCase());
    setState(() {
      _entries = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final top3 = _entries.take(3).toList();
    final rest = _entries.skip(3).toList();
    final userEntry = _entries.firstWhere((e) => e.isCurrentUser, orElse: () => _entries.last);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 🌲 Scenic Forest Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/bg_gameplay.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Header & Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.topCampers,
                            style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              'Season 1',
                              style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Timeframe Switcher
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTabChip('Daily', AppStrings.dailyTab),
                            _buildTabChip('Weekly', AppStrings.weeklyTab),
                            _buildTabChip('Global', AppStrings.globalTab),
                            _buildTabChip('Thailand', AppStrings.thailandTab),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Top 3 Podium
                          if (top3.length >= 3)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // #2 Silver
                                  _buildPodiumItem(top3[1], height: 90, rankColor: const Color(0xFF94A3B8), medal: '🥈'),
                                  const SizedBox(width: 12),
                                  // #1 Gold
                                  _buildPodiumItem(top3[0], height: 115, rankColor: const Color(0xFFF59E0B), medal: '🥇'),
                                  const SizedBox(width: 12),
                                  // #3 Bronze
                                  _buildPodiumItem(top3[2], height: 80, rankColor: const Color(0xFFD97706), medal: '🥉'),
                                ],
                              ),
                            ),

                          const SizedBox(height: 10),

                          // Rest List (#4 to #10)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rest.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 6),
                            itemBuilder: (context, index) {
                              final entry = rest[index];
                              return _buildRankRow(entry);
                            },
                          ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),

                // Sticky Bottom User Rank Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    border: const Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: _buildRankRow(userEntry, isHighlight: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String key, String label) {
    final isSelected = key == _selectedTab;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.labelSmall.copyWith(
          color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
        backgroundColor: AppColors.surfaceContainerLow,
        onSelected: (val) {
          if (val) {
            setState(() => _selectedTab = key);
            _loadData();
          }
        },
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, {required double height, required Color rankColor, required String medal}) {
    return Column(
      children: [
        CritterAvatar(emoji: entry.avatarEmoji, size: 48),
        const SizedBox(height: 4),
        Text(entry.playerName, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700)),
        Text('${entry.score} pts', style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10)),
        const SizedBox(height: 6),
        Container(
          width: 85,
          height: height,
          decoration: BoxDecoration(
            color: rankColor.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: rankColor, width: 1.5),
          ),
          child: Center(
            child: Text(medal, style: const TextStyle(fontSize: 24)),
          ),
        ),
      ],
    );
  }

  Widget _buildRankRow(LeaderboardEntry entry, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.primaryContainer.withValues(alpha: 0.6) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isHighlight ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#${entry.rank}',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: isHighlight ? AppColors.primaryDark : AppColors.outline,
              ),
            ),
          ),
          CritterAvatar(emoji: entry.avatarEmoji, size: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.playerName,
                  style: AppTypography.titleMedium.copyWith(fontSize: 13),
                ),
                Text(
                  'Time: ${entry.solveTime} • ${entry.countryCode}',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '${entry.score}',
            style: AppTypography.titleMedium.copyWith(
              color: isHighlight ? AppColors.primaryDark : AppColors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
