import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_avatar.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../data/models/player_profile.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/identity/player_identity_service.dart';
import '../../../services/sync/cloud_sync_service.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepository;
  final PlayerIdentityService identityService;
  final CloudSyncService syncService;
  final VoidCallback onOpenSettings;
  final VoidCallback? onOpenLeaderboard;
  final VoidCallback? onOpenFirstLaunch;

  const ProfileScreen({
    super.key,
    required this.authRepository,
    required this.identityService,
    required this.syncService,
    required this.onOpenSettings,
    this.onOpenLeaderboard,
    this.onOpenFirstLaunch,
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

  void _showConnectAccountDialog() {
    final emailController = TextEditingController();
    final nameController = TextEditingController(text: _profile?.username ?? 'CozyCamper');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: Row(
            children: [
              const Icon(Icons.cloud_upload_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Connect Account', style: AppTypography.titleLarge),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect your account to enable multi-device cloud saves. All your existing stage progress and acorns will be preserved!',
                style: AppTypography.bodyMedium.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'camper@example.com',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Camper Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () async {
                final email = emailController.text.trim();
                final name = nameController.text.trim();
                if (email.isNotEmpty) {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final userId = 'usr_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
                  await widget.identityService.connectAccount(
                    userId: userId,
                    email: email,
                    displayName: name.isNotEmpty ? name : 'CozyCamper',
                  );
                  await widget.syncService.syncPendingProgress();
                  navigator.pop();
                  _loadProfile();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Account connected! All progress merged.')),
                  );
                }
              },
              child: const Text('Connect & Sync'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final p = _profile!;
    final isGuest = widget.identityService.isGuest;

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
                child: Column(
                  children: [
                    Row(
                      children: [
                        CritterAvatar(emoji: p.avatarEmoji, size: 68),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.identityService.currentIdentity.displayName,
                                    style: AppTypography.titleLarge,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    ),
                                    child: Text(
                                      'Lvl ${p.level}',
                                      style: AppTypography.labelSmall.copyWith(
                                        fontSize: 10,
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.rankTitle} • ${widget.identityService.effectivePlayerId}',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.outline),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isGuest ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isGuest ? Icons.phone_android_rounded : Icons.cloud_done_rounded,
                                      size: 12,
                                      color: isGuest ? const Color(0xFFD97706) : const Color(0xFF15803D),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isGuest ? 'Guest (Saved on Device)' : 'Cloud Save Enabled',
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isGuest ? const Color(0xFF92400E) : const Color(0xFF15803D),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (isGuest) ...[
                      const SizedBox(height: AppSpacing.md),
                      CritterButton(
                        text: 'Connect Account (Enable Cloud Save)',
                        variant: CritterButtonVariant.secondary,
                        isFullWidth: true,
                        icon: Icons.cloud_upload_rounded,
                        onPressed: _showConnectAccountDialog,
                      ),
                    ],
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
                  _buildStatCard('Stages Cleared', '${p.puzzlesSolved}', Icons.extension_rounded, AppColors.primary),
                  _buildStatCard('Perfect Clears', '${p.perfectClears}', Icons.star_rounded, AppColors.accentGold),
                  _buildStatCard('Current Streak', '${p.streakDays} Days', Icons.local_fire_department_rounded, const Color(0xFFEA580C)),
                  _buildStatCard('Total Acorns', '${p.totalAcorns}', Icons.grain_rounded, AppColors.textAccentBrown),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              if (widget.onOpenLeaderboard != null)
                CritterCard(
                  backgroundColor: const Color(0xFFF3F4F6),
                  borderRadius: AppSpacing.radiusMd,
                  onTap: widget.onOpenLeaderboard,
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: const Center(child: Text('🏆', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Camp Leaderboard', style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                            Text('View Weekly & Thailand Rankings', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
                    ],
                  ),
                ),

              if (widget.onOpenFirstLaunch != null) ...[
                const SizedBox(height: 8),
                CritterCard(
                  backgroundColor: const Color(0xFFFBF6EE),
                  borderRadius: AppSpacing.radiusMd,
                  onTap: widget.onOpenFirstLaunch,
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: const Center(child: Text('⛺', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome / Account Portal', style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                            Text('Switch Account • Play as Guest • Register', style: AppTypography.labelSmall.copyWith(color: AppColors.outline)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
                    ],
                  ),
                ),
              ],

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
