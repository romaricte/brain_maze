import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const _boxName = 'brain_maze';
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  // Stars
  int getStars(int levelId) => _box.get('stars_$levelId', defaultValue: 0);

  void saveStars(int levelId, int stars) {
    final current = getStars(levelId);
    if (stars > current) {
      _box.put('stars_$levelId', stars);
    }
  }

  // Best time
  double getBestTime(int levelId) =>
      _box.get('time_$levelId', defaultValue: 999.0);

  void saveBestTime(int levelId, double time) {
    final current = getBestTime(levelId);
    if (time < current) {
      _box.put('time_$levelId', time);
    }
  }

  // Settings
  bool getUseAccelerometer() =>
      _box.get('use_accelerometer', defaultValue: false);
  void setUseAccelerometer(bool val) => _box.put('use_accelerometer', val);

  bool getSoundEnabled() => _box.get('sound_enabled', defaultValue: true);
  void setSoundEnabled(bool val) => _box.put('sound_enabled', val);

  bool getVibrationEnabled() =>
      _box.get('vibration_enabled', defaultValue: true);
  void setVibrationEnabled(bool val) => _box.put('vibration_enabled', val);

  // Reset
  void resetAll() => _box.clear();
}