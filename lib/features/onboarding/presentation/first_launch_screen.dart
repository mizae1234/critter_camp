import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/critter_button.dart';

class FirstLaunchScreen extends StatelessWidget {
  final VoidCallback onStartPlaying;
  final VoidCallback onHowToPlay;

  const FirstLaunchScreen({
    super.key,
    required this.onStartPlaying,
    required this.onHowToPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Hero Cozy Camp Illustration Card
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF6EE),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8D5B4C).withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFE8DCB8), width: 1.5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft background glow
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFEF3C7),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⛺', style: TextStyle(fontSize: 72)),
                        Transform.translate(
                          offset: const Offset(0, -15),
                          child: const Text('🦊', style: TextStyle(fontSize: 42)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Title
              Text(
                'Critter Camp',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.sm),

              // Tagline
              Text(
                'Find a home for every critter.',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Action 1: Start Playing
              CritterButton(
                text: 'Start Playing',
                isFullWidth: true,
                icon: Icons.play_arrow_rounded,
                onPressed: onStartPlaying,
              ),

              const SizedBox(height: AppSpacing.md),

              // Action 2: How to Play
              CritterButton(
                text: 'How to Play',
                variant: CritterButtonVariant.secondary,
                isFullWidth: true,
                onPressed: onHowToPlay,
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
