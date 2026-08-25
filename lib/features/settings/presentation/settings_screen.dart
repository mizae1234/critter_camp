import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../core/localization/app_strings.dart';
import '../../../services/config/app_config_service.dart';
import '../../../services/sync/cloud_sync_service.dart';
import '../../../services/audio/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  final LocalStorage storage;
  final CloudSyncService? syncService;
  final AppConfigService? configService;
  final AudioService? audioService;
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.storage,
    this.syncService,
    this.configService,
    this.audioService,
    required this.onBack,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _zenMode;
  late bool _patternMode;
  late double _musicVolume;
  late double _sfxVolume;
  late String _language;
  bool _isManualSyncing = false;

  @override
  void initState() {
    super.initState();
    _zenMode = widget.storage.getZenMode();
    _patternMode = widget.storage.getPatternMode();
    _musicVolume = widget.storage.getMusicVolume();
    _sfxVolume = widget.storage.getSfxVolume();
    _language = widget.storage.getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final String lastSync = widget.storage.getLastSyncTime() != null
        ? 'Last Synced: ${widget.storage.getLastSyncTime()!.split('T').first}'
        : 'Synced with device storage';

    final String appId = widget.configService?.config.appId ?? 'critter-camp';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBack,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          children: [
            // Section 0: Language Selection
            Text(AppStrings.languageSetting, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                    title: const Text('English (US)', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Display in English', style: TextStyle(fontSize: 12)),
                    trailing: _language == 'en' ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                    onTap: () {
                      setState(() => _language = 'en');
                      widget.storage.setLanguage('en');
                      AppStrings.currentLocale.value = 'en';
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Text('🇹🇭', style: TextStyle(fontSize: 24)),
                    title: const Text('ภาษาไทย (Thai)', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('แสดงผลภาษาไทย', style: TextStyle(fontSize: 12)),
                    trailing: _language == 'th' ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                    onTap: () {
                      setState(() => _language = 'th');
                      widget.storage.setLanguage('th');
                      AppStrings.currentLocale.value = 'th';
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 1: Gameplay & Comfort
            Text(AppStrings.gameplayComfort, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(AppStrings.zenMode),
                    subtitle: Text(AppStrings.zenModeSub, style: const TextStyle(fontSize: 12)),
                    value: _zenMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _zenMode = val);
                      widget.storage.setZenMode(val);
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: Text(AppStrings.highContrast),
                    subtitle: Text(AppStrings.highContrastSub, style: const TextStyle(fontSize: 12)),
                    value: _patternMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _patternMode = val);
                      widget.storage.setPatternMode(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 2: Audio
            Text(AppStrings.soundAndAtmosphere, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.campfireMusic, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${(_musicVolume * 100).toInt()}%', style: AppTypography.labelSmall),
                    ],
                  ),
                  Slider(
                    value: _musicVolume,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _musicVolume = val);
                      widget.storage.setMusicVolume(val);
                      widget.audioService?.setMusicVolume(val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.sfxVolume, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${(_sfxVolume * 100).toInt()}%', style: AppTypography.labelSmall),
                    ],
                  ),
                  Slider(
                    value: _sfxVolume,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _sfxVolume = val);
                      widget.storage.setSfxVolume(val);
                      widget.audioService?.setSfxVolume(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 3: Cloud & Backend Sync
            Text(AppStrings.accountAndSync, style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_sync_rounded, color: AppColors.primary),
                    title: const Text('Cloud Sync Status'),
                    subtitle: Text(lastSync, style: const TextStyle(fontSize: 12)),
                    trailing: _isManualSyncing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : IconButton(
                            icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
                            tooltip: 'Sync Now',
                            onPressed: () async {
                              if (widget.syncService != null) {
                                final messenger = ScaffoldMessenger.of(context);
                                setState(() => _isManualSyncing = true);
                                await widget.syncService!.syncPendingProgress();
                                setState(() => _isManualSyncing = false);
                                messenger.showSnackBar(
                                  const SnackBar(content: Text('Cloud sync completed!')),
                                );
                              }
                            },
                          ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.app_settings_alt_rounded, color: AppColors.outline),
                    title: const Text('Platform App ID'),
                    subtitle: Text('Registered as "$appId"', style: const TextStyle(fontSize: 12)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        'Web Admin',
                        style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.primaryDark, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined, color: AppColors.outline),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Center(
              child: Text(
                'Critter Camp v1.0.0 • Build 42\nIntegrated with web/myapp platform',
                style: AppTypography.labelSmall.copyWith(color: AppColors.outline, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
