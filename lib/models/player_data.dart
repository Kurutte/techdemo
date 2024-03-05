import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;

  int _lives = 3;

<<<<<<< HEAD
  bool isHit = false;

=======
  double _power = 0.0;

  bool isHit = false;

  int _currentScore = 0 ; 

>>>>>>> 127f3c07ce8d27e7b95ba2ea6bb4e5c5f6d4f665
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
