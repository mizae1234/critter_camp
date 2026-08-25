import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/localization/app_strings.dart';

class FirstLaunchScreen extends StatelessWidget {
  final bool isReturningPlayer;
  final int currentStageNumber;
  final String? playerName;
  final VoidCallback onContinueGame;
  final VoidCallback onPlayAsGuest;
  final Function(String email, String name) onSignIn;
  final VoidCallback onHowToPlay;

  const FirstLaunchScreen({
    super.key,
    this.isReturningPlayer = false,
    this.currentStageNumber = 1,
    this.playerName,
    required this.onContinueGame,
    required this.onPlayAsGuest,
    required this.onSignIn,
    required this.onHowToPlay,
  });

  void _showSignInDialog(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController(text: playerName ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
        title: Row(
          children: [
            const Icon(Icons.account_circle_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(AppStrings.isThai ? 'เข้าสู่ระบบ / สมัครสมาชิก' : 'Sign In / Register', style: AppTypography.titleLarge),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.isThai
                  ? 'เข้าสู่ระบบเพื่อบันทึกด่านและเหรียญลูกโอ๊กลง Cloud อัตโนมัติ'
                  : 'Sign in to sync your progress and acorns across devices via cloud.',
              style: AppTypography.bodyMedium.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppStrings.isThai ? 'อีเมล' : 'Email Address',
                hintText: 'camper@example.com',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppStrings.isThai ? 'ชื่อผู้เล่น (Camper Name)' : 'Camper Name',
                hintText: 'CozyFox',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: '🇹🇭 TH',
              decoration: InputDecoration(
                labelText: AppStrings.isThai ? 'ประเทศ (สำหรับ Leaderboard)' : 'Country (for Leaderboard)',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: '🇹🇭 TH', child: Text('🇹🇭 Thailand (ไทย)')),
                DropdownMenuItem(value: '🇯🇵 JP', child: Text('🇯🇵 Japan')),
                DropdownMenuItem(value: '🇺🇸 US', child: Text('🇺🇸 United States')),
                DropdownMenuItem(value: '🇬🇧 GB', child: Text('🇬🇧 United Kingdom')),
                DropdownMenuItem(value: '🇰🇷 KR', child: Text('🇰🇷 South Korea')),
                DropdownMenuItem(value: '🇸🇬 SG', child: Text('🇸🇬 Singapore')),
                DropdownMenuItem(value: '🌍 GL', child: Text('🌍 Global / Other')),
              ],
              onChanged: (val) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStrings.isThai ? 'ยกเลิก' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              final email = emailController.text.trim();
              final name = nameController.text.trim();
              if (email.isNotEmpty) {
                Navigator.of(ctx).pop();
                onSignIn(email, name.isNotEmpty ? name : 'CozyCamper');
              }
            },
            child: Text(AppStrings.isThai ? 'เข้าสู่ระบบ' : 'Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cozy Campsite Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/images/bg_campsite.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Hero App Icon
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8D5B4C).withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        'assets/images/app_icon.jpg',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 140,
                          height: 140,
                          color: const Color(0xFFFBF6EE),
                          child: const Center(child: Text('⛺🦊', style: TextStyle(fontSize: 48))),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Title
                  Text(
                    AppStrings.appTitle,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Tagline
                  Text(
                    AppStrings.appTagline,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Dynamic Actions based on Returning Player status
                  if (isReturningPlayer) ...[
                    // Primary Continue Action
                    CritterButton(
                      text: AppStrings.isThai
                          ? '🏕️ เล่นต่อ (ด่านที่ $currentStageNumber)'
                          : '🏕️ Continue Journey (Stage $currentStageNumber)',
                      isFullWidth: true,
                      icon: Icons.play_arrow_rounded,
                      onPressed: onContinueGame,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Switch / Account Action
                    CritterButton(
                      text: AppStrings.isThai
                          ? '👤 ${playerName ?? "ผู้เล่น"} (สลับบัญชี)'
                          : '👤 ${playerName ?? "Camper"} (Switch Account)',
                      variant: CritterButtonVariant.secondary,
                      isFullWidth: true,
                      icon: Icons.account_circle_outlined,
                      onPressed: () => _showSignInDialog(context),
                    ),
                  ] else ...[
                    // Play as Guest
                    CritterButton(
                      text: AppStrings.playAsGuest,
                      isFullWidth: true,
                      icon: Icons.play_arrow_rounded,
                      onPressed: onPlayAsGuest,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    // Sign In / Register
                    CritterButton(
                      text: AppStrings.signInOrRegister,
                      variant: CritterButtonVariant.secondary,
                      isFullWidth: true,
                      icon: Icons.login_rounded,
                      onPressed: () => _showSignInDialog(context),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.sm),

                  // How to Play Action
                  CritterButton(
                    text: AppStrings.howToPlay,
                    variant: CritterButtonVariant.ghost,
                    isFullWidth: true,
                    icon: Icons.menu_book_rounded,
                    onPressed: onHowToPlay,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    AppStrings.offlineFriendly,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.outline,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
