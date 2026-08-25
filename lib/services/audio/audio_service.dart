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

  Future<void> _playAsset(String path) async {
    if (_isMuted || _sfxVolume <= 0.01) return;
    try {
      if (_sfxPlayer != null) {
        await _sfxPlayer!.stop();
        await _sfxPlayer!.setVolume(_sfxVolume);
        await _sfxPlayer!.play(AssetSource(path));
      }
    } catch (_) {}
  }

  /// 🐿️ Play Cozy Critter Placement Sound
  Future<void> playPlaceCritter() async {
    try { HapticFeedback.lightImpact(); } catch (_) {}
    await _playAsset('audio/pop.wav');
  }

  /// ❌ Play Wooden X Mark Sound
  Future<void> playMarkX() async {
    try { HapticFeedback.selectionClick(); } catch (_) {}
    await _playAsset('audio/click.wav');
  }

  /// ⚠️ Play Rule Violation / Conflict Sound
  Future<void> playConflict() async {
    try { HapticFeedback.mediumImpact(); } catch (_) {}
    await _playAsset('audio/error.wav');
  }

  /// ↩️ Play Undo Sound
  Future<void> playUndo() async {
    try { HapticFeedback.selectionClick(); } catch (_) {}
    await _playAsset('audio/undo.wav');
  }

  /// 💡 Play Hint Chime Sound
  Future<void> playHint() async {
    try { HapticFeedback.lightImpact(); } catch (_) {}
    await _playAsset('audio/hint.wav');
  }

  /// 🏆 Play Level Victory Fanfare Sound
  Future<void> playVictory() async {
    try { HapticFeedback.heavyImpact(); } catch (_) {}
    await _playAsset('audio/victory.wav');
  }

  /// 🔘 Play UI Button Tap Sound
  Future<void> playButtonTap() async {
    try { HapticFeedback.selectionClick(); } catch (_) {}
    await _playAsset('audio/click.wav');
  }

  void dispose() {
    try {
      _sfxPlayer?.dispose();
      _bgmPlayer?.dispose();
    } catch (_) {}
  }
}
