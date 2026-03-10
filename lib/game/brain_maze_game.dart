import 'package:brain_maze/levels/level_data.dart';
import 'package:brain_maze/levels/level_model.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async' as async;

import 'components/ball.dart';
import 'components/wall.dart';
import 'components/goal.dart';
import 'components/trap.dart';
import 'components/teleporter.dart';
import 'components/moving_wall.dart';


enum GameState { playing, paused, won, lost }

class BrainMazeGame extends FlameGame with HasCollisionDetection, PanDetector {
  final int levelId;
  final Function(int stars, double time) onWin;
  final VoidCallback onLose;
  final Function(int) onTimeUpdate;

  late Ball _ball;
  late LevelModel _level;
  late double _tileSize;

  GameState state = GameState.playing;
  double _elapsedTime = 0;
  int _remainingTime = 0;

  // Contrôles
  async.StreamSubscription? _accelSub;
  bool useAccelerometer;

  BrainMazeGame({
    required this.levelId,
    required this.onWin,
    required this.onLose,
    required this.onTimeUpdate,
    this.useAccelerometer = false,
  });

  @override
  Future<void> onLoad() async {
    _level = LevelData.allLevels.firstWhere((l) => l.id == levelId);
    _remainingTime = _level.timeLimit;

    // Calculer la taille des tuiles
    _tileSize = size.x / _level.gridSize.x;

    // Couleur de fond
    // (le fond est géré par le Container Flutter parent)

    await _buildLevel();
    _setupControls();
  }

  Future<void> _buildLevel() async {
    // Ajouter les murs
    for (var wallData in _level.walls) {
      add(Wall(
        position: wallData.position * _tileSize,
        size: wallData.size * _tileSize,
      ));
    }

    // Ajouter les pièges
    for (var trapData in _level.traps) {
      add(Trap(
        position: trapData.position * _tileSize + Vector2.all(_tileSize / 2),
      ));
    }

    // Ajouter les téléporteurs
    for (var teleData in _level.teleporters) {
      final posA = teleData.positionA * _tileSize + Vector2.all(_tileSize / 2);
      final posB = teleData.positionB * _tileSize + Vector2.all(_tileSize / 2);

      add(Teleporter(position: posA, targetPosition: posB));
      add(Teleporter(position: posB, targetPosition: posA));
    }

    // Ajouter les murs mouvants
    for (var mwData in _level.movingWalls) {
      add(MovingWall(
        startPos: mwData.start * _tileSize,
        endPos: mwData.end * _tileSize,
        size: mwData.size * _tileSize,
        speed: mwData.speed,
      ));
    }

    // Ajouter le goal
    add(Goal(
      position: _level.goalPosition * _tileSize + Vector2.all(_tileSize / 2),
    ));

    // Ajouter la balle
    _ball = Ball(
      position: _level.startPosition * _tileSize + Vector2.all(_tileSize / 2),
    );
    add(_ball);
  }

  void _setupControls() {
    if (useAccelerometer) {
      _accelSub = accelerometerEventStream().listen((event) {
        if (state == GameState.playing) {
          _ball.applyForce(Vector2(event.x * -8, event.y * 8));
        }
      });
    }
  }

  // Contrôle par swipe/drag
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (state != GameState.playing || useAccelerometer) return;
    _ball.applyForce(Vector2(
      info.delta.global.x * 15,
      info.delta.global.y * 15,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != GameState.playing) return;

    _elapsedTime += dt;

    // Timer
    final newRemaining = _level.timeLimit - _elapsedTime.floor();
    if (newRemaining != _remainingTime) {
      _remainingTime = newRemaining;
      onTimeUpdate(_remainingTime);

      if (_remainingTime <= 0) {
        state = GameState.lost;
        onLose();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Fond de grille subtil
    final gridPaint = Paint()
      ..color = const Color(0xFF1A1A3E).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int x = 0; x <= _level.gridSize.x.toInt(); x++) {
      canvas.drawLine(
        Offset(x * _tileSize, 0),
        Offset(x * _tileSize, size.y),
        gridPaint,
      );
    }
    for (int y = 0; y <= _level.gridSize.y.toInt(); y++) {
      canvas.drawLine(
        Offset(0, y * _tileSize),
        Offset(size.x, y * _tileSize),
        gridPaint,
      );
    }

    super.render(canvas);
  }

  // Callbacks
  void onLevelComplete() {
    if (state != GameState.playing) return;
    state = GameState.won;

    // Calcul des étoiles
    final timeRatio = _elapsedTime / _level.timeLimit;
    int stars = 1;
    if (timeRatio < 0.5) {
      stars = 3;
    } else if (timeRatio < 0.75) {
      stars = 2;
    }

    onWin(stars, _elapsedTime);
  }

  void onPlayerDied() {
    if (state != GameState.playing) return;
    state = GameState.lost;
    onLose();
  }

  void onWallHit() {
    // Vibration feedback - géré côté Flutter
  }

  void restartLevel() {
    state = GameState.playing;
    _elapsedTime = 0;
    _remainingTime = _level.timeLimit;
    _ball.reset(_level.startPosition * _tileSize + Vector2.all(_tileSize / 2));
  }

  void togglePause() {
    if (state == GameState.playing) {
      state = GameState.paused;
      pauseEngine();
    } else if (state == GameState.paused) {
      state = GameState.playing;
      resumeEngine();
    }
  }

  @override
  void onRemove() {
    _accelSub?.cancel();
    super.onRemove();
  }
}