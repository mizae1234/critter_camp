import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/widgets/critter_card.dart';
import '../../../services/config/app_config_service.dart';
import '../../../services/sync/cloud_sync_service.dart';

class SettingsScreen extends StatefulWidget {
  final LocalStorage storage;
  final CloudSyncService? syncService;
  final AppConfigService? configService;
  final VoidCallback onBack;

  const SettingsScreen({
    super.key,
    required this.storage,
    this.syncService,
    this.configService,
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
  bool _isManualSyncing = false;

  @override
  void initState() {
    super.initState();
    _zenMode = widget.storage.getZenMode();
    _patternMode = widget.storage.getPatternMode();
    _musicVolume = widget.storage.getMusicVolume();
    _sfxVolume = widget.storage.getSfxVolume();
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
            // Section 1: Gameplay & Comfort
            Text('Gameplay & Comfort', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Zen Mode'),
                    subtitle: const Text('Play with unlimited lives and no mistake penalty', style: TextStyle(fontSize: 12)),
                    value: _zenMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _zenMode = val);
                      widget.storage.setZenMode(val);
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Colorblind Patterns'),
                    subtitle: const Text('Show tactile letter codes and patterns on habitats', style: TextStyle(fontSize: 12)),
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
            Text('Sound & Atmosphere', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            CritterCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Campfire Music', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${(_musicVolume * 100).toInt()}%', style: AppTypography.labelSmall),
                    ],
                  ),
                  Slider(
                    value: _musicVolume,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _musicVolume = val);
                      widget.storage.setMusicVolume(val);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sound Effects (SFX)', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${(_sfxVolume * 100).toInt()}%', style: AppTypography.labelSmall),
                    ],
                  ),
                  Slider(
                    value: _sfxVolume,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _sfxVolume = val);
                      widget.storage.setSfxVolume(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Section 3: Cloud & Backend Sync
            Text('Account & Cloud Sync', style: AppTypography.titleMedium),
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
