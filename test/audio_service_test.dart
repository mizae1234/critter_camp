import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:critter_camp/core/storage/local_storage.dart';
import 'package:critter_camp/services/audio/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioService SFX & Volume Control Tests', () {
    late LocalStorage storage;
    late AudioService audioService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = await LocalStorage.getInstance();
      audioService = AudioService(storage: storage, enableAudioPlayers: false);
    });

    test('Initializes with default volume and respects settings', () {
      expect(audioService.sfxVolume, 1.0);
      expect(audioService.musicVolume, 0.8);
      expect(audioService.isMuted, isFalse);
    });

    test('Adjusting SFX volume persists to storage', () {
      audioService.setSfxVolume(0.5);
      expect(audioService.sfxVolume, 0.5);
      expect(storage.getSfxVolume(), 0.5);
    });

    test('Adjusting Music volume persists to storage', () {
      audioService.setMusicVolume(0.3);
      expect(audioService.musicVolume, 0.3);
      expect(storage.getMusicVolume(), 0.3);
    });

    test('Toggling mute disables volume', () {
      audioService.toggleMute();
      expect(audioService.isMuted, isTrue);
      audioService.toggleMute();
      expect(audioService.isMuted, isFalse);
    });

    test('Audio playback triggers execute safely without crashing', () async {
      await audioService.playPlaceCritter();
      await audioService.playMarkX();
      await audioService.playConflict();
      await audioService.playUndo();
      await audioService.playHint();
      await audioService.playVictory();
      await audioService.playButtonTap();
    });
  });
}
