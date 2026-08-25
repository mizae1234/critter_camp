import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';
import '../../../core/localization/app_strings.dart';

class FirstLaunchScreen extends StatelessWidget {
  final VoidCallback onPlayAsGuest;
  final Function(String email, String name) onSignIn;
  final VoidCallback onHowToPlay;

  const FirstLaunchScreen({
    super.key,
    required this.onPlayAsGuest,
    required this.onSignIn,
    required this.onHowToPlay,
  });

  void _showSignInDialog(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Hero Cozy Camp Illustration Card
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EE),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8D5B4C).withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFE8DCB8), width: 1.5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFEF3C7),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⛺', style: TextStyle(fontSize: 60)),
                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: const Text('🦊', style: TextStyle(fontSize: 36)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                AppStrings.appTitle,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
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
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Action 1: Play as Guest
              CritterButton(
                text: AppStrings.playAsGuest,
                isFullWidth: true,
                icon: Icons.play_arrow_rounded,
                onPressed: onPlayAsGuest,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Action 2: Sign In / Register
              CritterButton(
                text: AppStrings.signInOrRegister,
                variant: CritterButtonVariant.secondary,
                isFullWidth: true,
                icon: Icons.login_rounded,
                onPressed: () => _showSignInDialog(context),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Action 3: How to Play
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
    );
  }
}
