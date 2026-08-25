import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/storage/local_storage.dart';

class AudioService {
  final LocalStorage storage;
  final bool enableAudioPlayers;
  AudioPlayer? _sfxPlayer;
  AudioPlayer? _bgmPlayer;
  
  double _sfxVolume = 0.8;
  double _musicVolume = 0.6;
  bool _isMuted = false;

  AudioService({required this.storage, this.enableAudioPlayers = true}) {
    _loadVolumes();
    if (enableAudioPlayers) {
      _initPlayers();
    }
  }

  void _initPlayers() {
    try {
      _sfxPlayer = AudioPlayer();
      _bgmPlayer = AudioPlayer();
      _sfxPlayer?.setVolume(_sfxVolume);
      _bgmPlayer?.setVolume(_musicVolume);
      _bgmPlayer?.setReleaseMode(ReleaseMode.loop);
    } catch (_) {}
  }

  void _loadVolumes() {
    _sfxVolume = storage.getSfxVolume();
    _musicVolume = storage.getMusicVolume();
  }

  double get sfxVolume => _sfxVolume;
  double get musicVolume => _musicVolume;
  bool get isMuted => _isMuted;

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    storage.setSfxVolume(_sfxVolume);
    try {
      _sfxPlayer?.setVolume(_sfxVolume);
    } catch (_) {}
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    storage.setMusicVolume(_musicVolume);
    try {
      _bgmPlayer?.setVolume(_musicVolume);
    } catch (_) {}
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    try {
      if (_isMuted) {
        _sfxPlayer?.setVolume(0);
        _bgmPlayer?.setVolume(0);
      } else {
        _sfxPlayer?.setVolume(_sfxVolume);
        _bgmPlayer?.setVolume(_musicVolume);
      }
    } catch (_) {}
  }

  /// 🐿️ Play Cozy Critter Placement Sound
  Future<void> playPlaceCritter() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// ❌ Play Wooden X Mark Sound
  Future<void> playMarkX() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// ⚠️ Play Rule Violation / Conflict Sound
  Future<void> playConflict() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.alert);
    } catch (_) {}
  }

  /// ↩️ Play Undo Sound
  Future<void> playUndo() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// 💡 Play Hint Chime Sound
  Future<void> playHint() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.lightImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// 🏆 Play Level Victory Fanfare Sound
  Future<void> playVictory() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.heavyImpact();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// 🔘 Play UI Button Tap Sound
  Future<void> playButtonTap() async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      HapticFeedback.selectionClick();
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  void dispose() {
    try {
      _sfxPlayer?.dispose();
      _bgmPlayer?.dispose();
    } catch (_) {}
  }
}
