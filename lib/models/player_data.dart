import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 3;

  bool isHit = false;

  double _power = 0.0;

  int _currentScore = 0;

  String body = 'Astro';
  String color = 'Blue';
  String hat = 'NoHat';

  int get lives => _lives;
  set lives(int value) {
    if (value <= 3 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  double get power => _power;
  set power(double value) {
    _power = value;
    notifyListeners();
  }

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    save();
  }
}
