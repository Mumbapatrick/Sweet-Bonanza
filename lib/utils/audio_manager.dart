import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _soundEnabled = true;
  bool _musicEnabled = true;

  AudioManager._internal();

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;

  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
  }

  void toggleMusic(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      _musicPlayer.stop();
    }
  }

  Future<void> playSfx(String assetPath) async {
    if (_soundEnabled) {
      await _sfxPlayer.play(AssetSource(assetPath));
    }
  }

  Future<void> playBackgroundMusic(String assetPath, {bool loop = true}) async {
    if (_musicEnabled) {
      await _musicPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      await _musicPlayer.play(AssetSource(assetPath));
    }
  }

  void stopMusic() {
    _musicPlayer.stop();
  }
}
