import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../data/models/player_profile.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final VoidCallback onOpenSettings;

  const ProfileScreen({
    super.key,
    required this.authRepository,
    required this.onOpenSettings,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PlayerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final p = await widget.authRepository.getCurrentProfile();
    setState(() => _profile = p);
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final p = _profile!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Camper Profile',
                    style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: widget.onOpenSettings,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Profile Card
              CritterCard(
                backgroundColor: AppColors.surfaceContainerLow,
                borderRadius: AppSpacing.radiusLg,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    CritterAvatar(emoji: p.avatarEmoji, size: 70),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(p.username, style: AppTypography.titleLarge),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                ),
                                child: Text(
                                  'Lvl ${p.level}',
                                  style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${p.rankTitle} • ${p.camperId}',
                            style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_done_rounded, size: 12, color: Color(0xFF15803D)),
                                const SizedBox(width: 4),
                                Text(
                                  'Cloud Synced',
                                  style: AppTypography.labelSmall.copyWith(color: const Color(0xFF15803D), fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Stats 4-Grid
              Text('Camping Statistics', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard('Puzzles Solved', '${p.puzzlesSolved}', Icons.extension_rounded, AppColors.primary),
                  _buildStatCard('Perfect Clears', '${p.perfectClears}', Icons.star_rounded, AppColors.accentGold),
                  _buildStatCard('Current Streak', '${p.streakDays} Days', Icons.local_fire_department_rounded, const Color(0xFFEA580C)),
                  _buildStatCard('Total Acorns', '${p.totalAcorns}', Icons.grain_rounded, AppColors.textAccentBrown),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Badges Section
              Text('Badges & Achievements', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.sm),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: p.badges.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final badge = p.badges[index];
                  return CritterCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        Text(badge.iconEmoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(badge.title, style: AppTypography.titleMedium.copyWith(fontSize: 13)),
                              Text(badge.description, style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 11)),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return CritterCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.outline, fontSize: 11)),
              Icon(icon, size: 18, color: iconColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}
