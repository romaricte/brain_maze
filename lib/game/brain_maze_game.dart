import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async' as async;

import '../core/constants.dart';
import 'components/ball.dart';
import 'components/wall.dart';
import 'components/goal.dart';
import 'components/trap.dart';
import 'components/teleporter.dart';
import 'components/moving_wall.dart';
import 'components/collectible.dart';
import 'levels/level_model.dart';
import 'levels/level_data.dart';

enum GameState { playing, paused, won, lost, countdown }

class BrainMazeGame extends FlameGame with HasCollisionDetection, PanDetector {
  final int levelId;
  final Function(int stars, double time, int score) onWin;
  final VoidCallback onLose;
  final Function(int) onTimeUpdate;
  final Function(int) onScoreUpdate;

  late Ball _ball;
  late LevelModel _level;
  late double _tileSize;
  late double _offsetY; // Pour centrer la grille verticalement

  GameState state = GameState.countdown;
  double _elapsedTime = 0;
  int _remainingTime = 0;
  int _score = 0;

  // Countdown
  double _countdownTime = 3.0;

  // Contrôles
  async.StreamSubscription? _accelSub;
  bool useAccelerometer;

  // Drag continu
  Vector2 _currentDragForce = Vector2.zero();
  bool _isDragging = false;

  BrainMazeGame({
    required this.levelId,
    required this.onWin,
    required this.onLose,
    required this.onTimeUpdate,
    required this.onScoreUpdate,
    this.useAccelerometer = false,
  });

  @override
  Color backgroundColor() => const Color(0xFF0A0E21);

  @override
  Future<void> onLoad() async {
    _level = LevelData.allLevels.firstWhere((l) => l.id == levelId);
    _remainingTime = _level.timeLimit;

    // Calculer la taille des tuiles basée sur la largeur de l'écran
    _tileSize = size.x / _level.gridSize.x;

    // Centrer la grille verticalement
    final gridHeight = _level.gridSize.y * _tileSize;
    _offsetY = (size.y - gridHeight) / 2;
    if (_offsetY < 0) _offsetY = 0;

    await _buildLevel();
    _setupControls();
  }

  Future<void> _buildLevel() async {
    // Ajouter les murs
    for (var wallData in _level.walls) {
      add(Wall(
        position: _gridToScreen(wallData.position),
        size: wallData.size * _tileSize,
      ));
    }

    // Ajouter les pièges
    for (var trapData in _level.traps) {
      add(Trap(
        position: _gridCenter(trapData.position),
        type: trapData.type,
      ));
    }

    // Ajouter les téléporteurs (paires)
    for (var teleData in _level.teleporters) {
      final posA = _gridCenter(teleData.positionA);
      final posB = _gridCenter(teleData.positionB);

      add(Teleporter(position: posA, targetPosition: posB, groupId: teleData.groupId));
      add(Teleporter(position: posB, targetPosition: posA, groupId: teleData.groupId));
    }

    // Ajouter les murs mouvants
    for (var mwData in _level.movingWalls) {
      add(MovingWall(
        startPos: _gridToScreen(mwData.start),
        endPos: _gridToScreen(mwData.end),
        size: mwData.size * _tileSize,
        speed: mwData.speed,
        delay: mwData.delay,
      ));
    }

    // Ajouter les collectibles
    for (var colData in _level.collectibles) {
      add(Collectible(
        position: _gridCenter(colData.position),
        points: colData.points,
      ));
    }

    // Ajouter l'objectif
    add(Goal(position: _gridCenter(_level.goalPosition)));

    // Ajouter la balle
    _ball = Ball(position: _gridCenter(_level.startPosition));
    add(_ball);
  }

  /// Convertit une position grille en position écran
  Vector2 _gridToScreen(Vector2 gridPos) {
    return Vector2(
      gridPos.x * _tileSize,
      gridPos.y * _tileSize + _offsetY,
    );
  }

  /// Centre d'une case de grille
  Vector2 _gridCenter(Vector2 gridPos) {
    return Vector2(
      gridPos.x * _tileSize + _tileSize / 2,
      gridPos.y * _tileSize + _offsetY + _tileSize / 2,
    );
  }

  void _setupControls() {
    if (useAccelerometer) {
      _accelSub = accelerometerEventStream().listen((event) {
        if (state == GameState.playing) {
          _ball.applyForce(Vector2(
            -event.x * GameConstants.accelerometerSensitivity,
            event.y * GameConstants.accelerometerSensitivity,
          ));
        }
      });
    }
  }

  // ========== CONTRÔLES TACTILES ==========

  @override
  void onPanStart(DragStartInfo info) {
    if (state != GameState.playing || useAccelerometer) return;
    _isDragging = true;
    _currentDragForce = Vector2.zero();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (state != GameState.playing || useAccelerometer) return;
    _currentDragForce = Vector2(
      info.delta.global.x * GameConstants.swipeSensitivity,
      info.delta.global.y * GameConstants.swipeSensitivity,
    );
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _isDragging = false;
    _currentDragForce = Vector2.zero();
  }

  @override
  void onPanCancel() {
    _isDragging = false;
    _currentDragForce = Vector2.zero();
  }

  // ========== GAME LOOP ==========

  @override
  void update(double dt) {
    super.update(dt);

    // Countdown
    if (state == GameState.countdown) {
      _countdownTime -= dt;
      if (_countdownTime <= 0) {
        state = GameState.playing;
      }
      return;
    }

    if (state != GameState.playing) return;

    // Appliquer la force du drag continu
    if (_isDragging && _currentDragForce.length > 0) {
      _ball.applyForce(_currentDragForce);
    }

    // Timer
    _elapsedTime += dt;
    final newRemaining = (_level.timeLimit - _elapsedTime).ceil();
    if (newRemaining != _remainingTime && newRemaining >= 0) {
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
    // Grille de fond
    _renderGrid(canvas);

    super.render(canvas);

    // Countdown overlay
    if (state == GameState.countdown) {
      _renderCountdown(canvas);
    }

    // Indicateur de départ et d'arrivée (texte)
    _renderLabels(canvas);
  }

  void _renderGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1A1A3E).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final gridW = _level.gridSize.x.toInt();
    final gridH = _level.gridSize.y.toInt();

    for (int x = 0; x <= gridW; x++) {
      canvas.drawLine(
        Offset(x * _tileSize, _offsetY),
        Offset(x * _tileSize, _offsetY + gridH * _tileSize),
        gridPaint,
      );
    }
    for (int y = 0; y <= gridH; y++) {
      canvas.drawLine(
        Offset(0, y * _tileSize + _offsetY),
        Offset(gridW * _tileSize, y * _tileSize + _offsetY),
        gridPaint,
      );
    }
  }

  void _renderCountdown(Canvas canvas) {
    // Fond semi-transparent
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF0A0E21).withOpacity(0.7),
    );

    final count = _countdownTime.ceil().clamp(1, 3);
    final progress = _countdownTime - _countdownTime.floor();
    final scale = 1.0 + progress * 0.5;
    final opacity = progress.clamp(0.0, 1.0);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: TextStyle(
          color: const Color(0xFF00D4FF).withOpacity(opacity),
          fontSize: 72 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  void _renderLabels(Canvas canvas) {
    if (state == GameState.countdown) return;

    // Indicateur "START"
    _renderLabel(
      canvas,
      "S",
      _gridCenter(_level.startPosition),
      const Color(0xFF00D4FF).withOpacity(0.3),
    );

    // Indicateur "GOAL" déjà visible via le composant Goal
  }

  void _renderLabel(Canvas canvas, String text, Vector2 pos, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(pos.x - textPainter.width / 2, pos.y + 18));
  }

  // ========== CALLBACKS ==========

  void onLevelComplete() {
    if (state != GameState.playing) return;
    state = GameState.won;

    final timeRatio = _elapsedTime / _level.timeLimit;
    int stars = 1;
    if (timeRatio < GameConstants.threeStarThreshold) {
      stars = 3;
    } else if (timeRatio < GameConstants.twoStarThreshold) {
      stars = 2;
    }

    // Bonus de score pour le temps restant
    _score += (_remainingTime * 10);

    onWin(stars, _elapsedTime, _score);
  }

  void onPlayerDied() {
    if (state != GameState.playing) return;
    state = GameState.lost;
    onLose();
  }

  void onWallHit() {
    // Le feedback haptique est géré côté Flutter (GameScreen)
  }

  void onCollectiblePickup(int points) {
    _score += points;
    onScoreUpdate(_score);
  }

  void restartLevel() {
    _elapsedTime = 0;
    _remainingTime = _level.timeLimit;
    _score = 0;
    _countdownTime = 3.0;
    state = GameState.countdown;

    _ball.reset(_gridCenter(_level.startPosition));

    // Re-ajouter les collectibles supprimés
    // (les collectibles se retirent eux-mêmes quand ramassés)
    for (var colData in _level.collectibles) {
      final existing = children.whereType<Collectible>();
      final alreadyExists = existing.any(
        (c) => (c.position - _gridCenter(colData.position)).length < 5,
      );
      if (!alreadyExists) {
        add(Collectible(
          position: _gridCenter(colData.position),
          points: colData.points,
        ));
      }
    }

    onTimeUpdate(_remainingTime);
    onScoreUpdate(_score);
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

  // Getters
  LevelModel get level => _level;
  int get score => _score;
  double get elapsedTime => _elapsedTime;
  int get remainingTime => _remainingTime;
}