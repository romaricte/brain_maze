import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../brain_maze_game.dart';
import 'wall.dart';
import 'goal.dart';
import 'trap.dart';
import 'teleporter.dart';
import 'moving_wall.dart';
import 'collectible.dart';

class Ball extends CircleComponent with CollisionCallbacks, HasGameRef<BrainMazeGame> {
  Vector2 velocity = Vector2.zero();
  bool isAlive = true;
  bool _hasReachedGoal = false;

  // Effet de trail
  final List<_TrailPoint> _trail = [];

  // Invincibilité temporaire après téléportation
  bool _isInvulnerable = false;
  double _invulnerableTimer = 0;

  // Animation de mort
  double _deathAnimProgress = 0;
  bool _isDying = false;

  Ball({required Vector2 position})
      : super(
          position: position,
          radius: GameConstants.ballRadius,
          anchor: Anchor.center,
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(
      radius: radius * 0.85, // Hitbox légèrement plus petite pour être "fair"
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Animation de mort
    if (_isDying) {
      _deathAnimProgress += dt * 3;
      if (_deathAnimProgress >= 1.0) {
        isAlive = false;
        gameRef.onPlayerDied();
      }
      return;
    }

    if (!isAlive || _hasReachedGoal) return;

    // Invulnérabilité
    if (_isInvulnerable) {
      _invulnerableTimer -= dt;
      if (_invulnerableTimer <= 0) {
        _isInvulnerable = false;
      }
    }

    // Appliquer la friction
    velocity *= GameConstants.friction;

    // Limiter la vitesse maximale
    if (velocity.length > GameConstants.maxSpeed) {
      velocity = velocity.normalized() * GameConstants.maxSpeed;
    }

    // Stopper si trop lent
    if (velocity.length < GameConstants.minVelocity) {
      velocity = Vector2.zero();
    }

    // Déplacer
    final newPos = position + velocity * dt;

    // Garder dans les limites de l'écran
    final gameSize = gameRef.size;
    newPos.x = newPos.x.clamp(radius, gameSize.x - radius);
    newPos.y = newPos.y.clamp(radius, gameSize.y - radius);

    position = newPos;

    // Mettre à jour le trail
    _updateTrail();
  }

  void _updateTrail() {
    if (velocity.length > GameConstants.minVelocity) {
      _trail.add(_TrailPoint(position: position.clone(), life: 1.0));
    }

    // Faire vieillir et supprimer le trail
    for (int i = _trail.length - 1; i >= 0; i--) {
      _trail[i].life -= 0.04;
      if (_trail[i].life <= 0) {
        _trail.removeAt(i);
      }
    }

    // Limiter la longueur du trail
    while (_trail.length > GameConstants.maxTrailLength) {
      _trail.removeAt(0);
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isAlive) return;

    // Animation de mort
    if (_isDying) {
      _renderDeathAnimation(canvas);
      return;
    }

    // Dessiner le trail
    _renderTrail(canvas);

    // Glow externe
    final glowOpacity = _isInvulnerable
        ? 0.1 + (sin(_invulnerableTimer * 20) + 1) / 2 * 0.3
        : 0.25;

    canvas.drawCircle(
      Offset.zero,
      radius + 10,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(glowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Glow moyen
    canvas.drawCircle(
      Offset.zero,
      radius + 5,
      Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Balle principale avec dégradé
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: _isInvulnerable
              ? const [Color(0xFFFFFFFF), Color(0xFFBD00FF), Color(0xFF5500AA)]
              : const [Color(0xFFFFFFFF), Color(0xFF00D4FF), Color(0xFF0066FF)],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Reflet
    canvas.drawCircle(
      const Offset(-3, -4),
      radius * 0.25,
      Paint()..color = Colors.white.withOpacity(0.8),
    );
  }

  void _renderTrail(Canvas canvas) {
    for (var point in _trail) {
      final relativePos = point.position - position;
      final trailRadius = radius * 0.6 * point.life;
      canvas.drawCircle(
        Offset(relativePos.x, relativePos.y),
        trailRadius,
        Paint()
          ..color = const Color(0xFF00D4FF).withOpacity(point.life * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  void _renderDeathAnimation(Canvas canvas) {
    final progress = _deathAnimProgress.clamp(0.0, 1.0);

    // Explosion de particules
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final distance = progress * 40;
      final particleOpacity = (1.0 - progress).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(cos(angle) * distance, sin(angle) * distance),
        radius * (1 - progress) * 0.5,
        Paint()
          ..color = const Color(0xFFFF006E).withOpacity(particleOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    // Balle qui rétrécit
    final shrink = (1.0 - progress).clamp(0.0, 1.0);
    canvas.drawCircle(
      Offset.zero,
      radius * shrink,
      Paint()
        ..color = Color.lerp(
          const Color(0xFF00D4FF),
          const Color(0xFFFF006E),
          progress,
        )!,
    );
  }

  void applyForce(Vector2 force) {
    if (!isAlive || _isDying || _hasReachedGoal) return;
    velocity += force;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (!isAlive || _isDying || _hasReachedGoal) return;

    if (other is Wall) {
      _handleWallCollision(intersectionPoints, other);
    } else if (other is MovingWall) {
      _handleWallCollision(intersectionPoints, other);
    } else if (other is Goal) {
      _handleGoalReached();
    } else if (other is Trap && !_isInvulnerable) {
      _handleTrapHit();
    } else if (other is Teleporter) {
      other.teleport(this);
    } else if (other is Collectible) {
      other.collect();
      gameRef.onCollectiblePickup(other.points);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Collision continue avec les murs (pour repousser en permanence)
    if (!isAlive || _isDying || _hasReachedGoal) return;

    if (other is Wall || other is MovingWall) {
      _pushOutOfWall(intersectionPoints, other);
    }
  }

  void _handleWallCollision(Set<Vector2> points, PositionComponent wall) {
    if (points.isEmpty) return;

    // Calculer le point de collision moyen
    final collisionPoint = points.reduce((a, b) => a + b) / points.length.toDouble();

    // Direction de la normale (du mur vers la balle)
    final normal = (position - collisionPoint).normalized();

    // Réfléchir la vélocité
    final dot = velocity.dot(normal);
    if (dot < 0) {
      velocity -= normal * (2 * dot);
      velocity *= GameConstants.bounceFactor;
    }

    // Repousser hors du mur
    position += normal * 2;

    gameRef.onWallHit();
  }

  void _pushOutOfWall(Set<Vector2> points, PositionComponent wall) {
    if (points.isEmpty) return;

    final collisionPoint = points.reduce((a, b) => a + b) / points.length.toDouble();
    final normal = (position - collisionPoint);

    if (normal.length > 0) {
      normal.normalize();
      position += normal * 1.5;
    }
  }

  void _handleGoalReached() {
    _hasReachedGoal = true;
    velocity = Vector2.zero();
    gameRef.onLevelComplete();
  }

  void _handleTrapHit() {
    _isDying = true;
    _deathAnimProgress = 0;
    velocity = Vector2.zero();
  }

  void setInvulnerable(double duration) {
    _isInvulnerable = true;
    _invulnerableTimer = duration;
  }

  void reset(Vector2 startPosition) {
    position = startPosition.clone();
    velocity = Vector2.zero();
    isAlive = true;
    _hasReachedGoal = false;
    _isDying = false;
    _deathAnimProgress = 0;
    _isInvulnerable = false;
    _trail.clear();
  }
}

class _TrailPoint {
  final Vector2 position;
  double life;
  _TrailPoint({required this.position, required this.life});
}