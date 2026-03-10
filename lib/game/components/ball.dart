import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'wall.dart';
import 'goal.dart';
import 'trap.dart';
import 'teleporter.dart';
import 'moving_wall.dart';
import '../brain_maze_game.dart';

class Ball extends CircleComponent with CollisionCallbacks, HasGameRef<BrainMazeGame> {
  Vector2 velocity = Vector2.zero();
  final double maxSpeed = 250;
  final double friction = 0.92;
  bool isAlive = true;

  // Trail effect
  final List<Vector2> _trail = [];
  final int _maxTrailLength = 15;

  Ball({required Vector2 position})
      : super(
          position: position,
          radius: 12,
          anchor: Anchor.center,
          priority: 10,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void render(Canvas canvas) {
    if (!isAlive) return;

    // Dessiner le trail (trainée lumineuse)
    for (int i = 0; i < _trail.length; i++) {
      final opacity = (i / _trail.length) * 0.5;
      final trailRadius = radius * (i / _trail.length) * 0.8;
      final relativePos = _trail[i] - position;
      canvas.drawCircle(
        Offset(relativePos.x, relativePos.y),
        trailRadius,
        Paint()
          ..color = const Color(0xFF00D4FF).withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    // Glow externe
    canvas.drawCircle(
      Offset.zero,
      radius + 8,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Glow moyen
    canvas.drawCircle(
      Offset.zero,
      radius + 4,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Balle principale
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFF00D4FF),
            Color(0xFF0066FF),
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Reflet
    canvas.drawCircle(
      const Offset(-3, -3),
      radius * 0.3,
      Paint()..color = Colors.white.withOpacity(0.7),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isAlive) return;

    // Trail
    _trail.add(position.clone());
    if (_trail.length > _maxTrailLength) {
      _trail.removeAt(0);
    }

    // Appliquer la friction
    velocity *= friction;

    // Limiter la vitesse
    if (velocity.length > maxSpeed) {
      velocity = velocity.normalized() * maxSpeed;
    }

    // Déplacer
    position += velocity * dt;

    // Stopper si trop lent
    if (velocity.length < 1) {
      velocity = Vector2.zero();
    }
  }

  void applyForce(Vector2 force) {
    velocity += force;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Wall || other is MovingWall) {
      _handleWallCollision(intersectionPoints, other);
    } else if (other is Goal) {
      gameRef.onLevelComplete();
    } else if (other is Trap) {
      _handleTrapCollision();
    } else if (other is Teleporter) {
      other.teleport(this);
    }
  }

  void _handleWallCollision(Set<Vector2> points, PositionComponent wall) {
    // Calculer la normale de collision
    final wallCenter = wall.position + wall.size / 2;
    final direction = position - wallCenter;
    direction.normalize();

    // Repousser la balle hors du mur
    position += direction * 2;

    // Réfléchir la vélocité
    if (direction.x.abs() > direction.y.abs()) {
      velocity.x = -velocity.x * 0.5;
    } else {
      velocity.y = -velocity.y * 0.5;
    }

    // Vibration haptique
    gameRef.onWallHit();
  }

  void _handleTrapCollision() {
    isAlive = false;
    gameRef.onPlayerDied();
  }

  void reset(Vector2 startPosition) {
    position = startPosition.clone();
    velocity = Vector2.zero();
    isAlive = true;
    _trail.clear();
  }
}