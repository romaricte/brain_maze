import 'package:flame_audio/flame_audio.dart';
import 'storage_service.dart';

class AudioService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      // Précharger les sons
      await FlameAudio.audioCache.loadAll([
        'ball_hit.mp3',
        'level_complete.mp3',
        'game_over.mp3',
        'teleport.mp3',
        'button_click.mp3',
        'star_earned.mp3',
        'collectible.mp3',
        'countdown.mp3',
      ]);
      _initialized = true;
    } catch (e) {
      // Pas de crash si les fichiers audio manquent
      print('Audio init warning: $e');
    }
  }

  static void play(String sound) {
    if (!_initialized) return;
    final storage = StorageService();
    if (!storage.getSoundEnabled()) return;

    try {
      FlameAudio.play(sound);
    } catch (e) {
      // Silencieux en cas d'erreur
    }
  }

  static void playBallHit() => play('ball_hit.mp3');
  static void playLevelComplete() => play('level_complete.mp3');
  static void playGameOver() => play('game_over.mp3');
  static void playTeleport() => play('teleport.mp3');
  static void playButtonClick() => play('button_click.mp3');
  static void playCollectible() => play('collectible.mp3');
  static void playCountdown() => play('countdown.mp3');

  // Musique de fond
  static Future<void> startBgMusic() async {
    final storage = StorageService();
    if (!storage.getSoundEnabled()) return;

    try {
      await FlameAudio.bgm.play('background_music.mp3', volume: 0.3);
    } catch (e) {
      // Silencieux
    }
  }

  static void stopBgMusic() {
    try {
      FlameAudio.bgm.stop();
    } catch (e) {
      // Silencieux
    }
  }

  static void dispose() {
    FlameAudio.bgm.dispose();
  }
}