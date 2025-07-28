// lib/models/shop_data.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/audio_manager.dart';
import 'package:flutter/material.dart';

class ShopData extends ChangeNotifier {
  int _credits;
  int _bet;
  final List<Map<String, dynamic>> _items;
  final List<String> _gameSymbols;

  bool _ambientMusicOn;
  bool _soundFxOn;
  String _selectedLanguage;
  final List<String> _availableLanguages;

  ShopData()
      : _credits = 842,
        _bet = 100,
        _items = <Map<String, dynamic>>[
          {
            'name': 'Candy Land',
            'image': 'assets/images/backgrounds/candyland.webp',
            'owned': true,
            'selected': false,
            'price': null,
          },
          {
            'name': 'Enchanted Confection',
            'image': 'assets/images/backgrounds/fantasy.webp',
            'owned': true,
            'selected': true,
            'price': null,
          },
          {
            'name': 'Sugarpunk Forge',
            'image': 'assets/images/backgrounds/candyland.webp',
            'owned': true,
            'price': null,
            'selected':true,
          },
          {
            'name': 'Candy Cybercore',
            'image': 'assets/images/backgrounds/cyber.webp',
            'owned': false,
            'price': 1600,
          },
          {
            'name': 'Sweet Ruins',
            'image': 'assets/images/backgrounds/apocalyptic.webp',
            'owned': false,
            'price': 2300,
          },
          {
            'name': 'Licorice Noir',
            'image': 'assets/images/backgrounds/noir.webp',
            'owned': false,
            'price': 2700,
          },
          {
            'name': 'Jullyverse',
            'image': 'assets/images/backgrounds/alien.webp',
            'owned': false,
            'price': 3100,
          }, {
            'name': 'Kingdom of Crumble',
            'image': 'assets/images/backgrounds/medieval.webp',
            'owned': false,
            'price': 4000,
          },
          {
            'name': 'Neon Nougat Nexus',
            'image': 'assets/images/backgrounds/scifi.webp',
            'owned': false,
            'price': 4200,
          }, {
            'name': 'Deep Sugar Reef',
            'image': 'assets/images/backgrounds/underwater.webp',
            'owned': false,
            'price': 5000,
          },
          {
            'name': 'Frosted Hollow',
            'image': 'assets/images/backgrounds/winter.webp',
            'owned': false,
            'price': 5500,
          },

        ],
        _gameSymbols = <String>[
          'Apple', 'Banana', 'Cherry', 'Grape', 'Lemon', 'Orange', 'Strawberry', 'Watermelon'
        ],
        _ambientMusicOn = true,
        _soundFxOn = true,
        _selectedLanguage = 'ENGLISH',
        _availableLanguages = <String>['ENGLISH', 'DEUTSCH', 'ESPANOL', 'FRANCAIS', 'ITALIANO', 'POLSKI', 'PORTUGUES'];

  int get credits => _credits;
  int get bet => _bet;
  List<Map<String, dynamic>> get items => _items;
  List<String> get gameSymbols => _gameSymbols;

  bool get ambientMusicOn => _ambientMusicOn;
  bool get soundFxOn => _soundFxOn;
  String get selectedLanguage => _selectedLanguage;
  List<String> get availableLanguages => _availableLanguages;

  void buyItem(int index) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      final int? price = item['price'];
      if (price != null && !item['owned'] && _credits >= price) {
        _credits -= price;
        item['owned'] = true;
        item['price'] = null;
        notifyListeners();
      }
    }
  }

  void selectItem(int index) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      if (item['owned']) {
        for (final i in _items) {
          i['selected'] = false;
        }
        item['selected'] = true;
        notifyListeners();
      }
    }
  }
  void increaseBet() {
    if (_bet == 1) _bet = 5;
    else if (_bet == 5) _bet = 10;
    else if (_bet == 10) _bet = 25;
    else if (_bet == 25) _bet = 50;
    else if (_bet == 50) _bet = 100;
    notifyListeners();
  }

  void decreaseBet() {
    if (_bet == 100) _bet = 50;
    else if (_bet == 50) _bet = 25;
    else if (_bet == 25) _bet = 10;
    else if (_bet == 10) _bet = 5;
    else if (_bet == 5) _bet = 1;
    notifyListeners();
  }


  void spinGame() {
    if (_credits >= _bet) {
      _credits -= _bet;
      notifyListeners();
    }
  }

  void winCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }

  final AudioManager _audioManager = AudioManager();

  void toggleAmbientMusic() {
    _ambientMusicOn = !_ambientMusicOn;
    if (_ambientMusicOn) {
      _audioManager.toggleMusic(true);
      _audioManager.playBackgroundMusic('sound/game_music.mp3'); // replace with your asset
    } else {
      _audioManager.toggleMusic(false);
    }
    notifyListeners();
  }

  void toggleSoundFx() {
    _soundFxOn = !_soundFxOn;
    _audioManager.toggleSound(_soundFxOn);
    notifyListeners();
  }

  void playTapSound() {
    if (_soundFxOn) _audioManager.playSfx('sound/tap.mp3');
  }

  void playWheelSpinSound() {
    if (_soundFxOn) _audioManager.playSfx('sound/wheel_playing.mp3');
  }

  void playWheelStopSound() {
    if (_soundFxOn) _audioManager.playSfx('sound/wheel_stop.mp3');
  }

  void playSymbolSound() {
    if (_soundFxOn) _audioManager.playSfx('sound/symbol_playing.mp3');
  }

  void playBackgroundMusic(String path) {
    if (_ambientMusicOn) {
      _audioManager.playBackgroundMusic(path);
    }
  }

  Future<void> loadAudioSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _ambientMusicOn = prefs.getBool('ambientMusic') ?? true;
    _soundFxOn = prefs.getBool('soundFx') ?? true;

    _audioManager.toggleMusic(_ambientMusicOn);
    _audioManager.toggleSound(_soundFxOn);

    notifyListeners();
  }

  void setLanguage(String? newLanguage) {
    if (newLanguage != null && _availableLanguages.contains(newLanguage)) {
      _selectedLanguage = newLanguage;
      notifyListeners();
    }
  }
}
