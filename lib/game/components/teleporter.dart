import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'ball.dart';

class Teleporter extends CircleComponent with CollisionCallbacks {
  final Vector2 targetPosition;
  final int groupId;
  double _time = 0;
  bool _cooldown = false;
  double _cooldownTimer = 0;

  // Particules de vortex
  final List<_VortexParticle> _vortex = [];

  Teleporter({
    required Vector2 position,
    required this.targetPosition,
    this.groupId = 0,
  }) : super(
          position: position,
          radius: GameConstants.teleporterRadius,
          anchor: Anchor.center,
          priority: 5,
        ) {
    final random = Random();
    for (int i = 0; i < 8; i++) {
      _vortex.add(_VortexParticle(
        angle: random.nextDouble() * 2 * pi,
        speed: 2.0 + random.nextDouble() * 2.0,
        radius: radius * 0.3 + random.nextDouble() * radius * 0.7,
        size: 1.0 + random.nextDouble() * 2.0,
      ));
    }
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius * 0.7));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (_cooldown) {
      _cooldownTimer -= dt;
      if (_cooldownTimer <= 0) {
        _cooldown = false;
      }
    }

    for (var p in _vortex) {
      p.angle += dt * p.speed;
      // Spiral vers le centre
      p.currentRadius = p.radius * (0.5 + 0.5 * sin(_time * 2 + p.angle));
    }
  }

  void teleport(Ball ball) {
    if (_cooldown) return;

    // Téléporter
    ball.position = targetPosition.clone();
    ball.velocity *= 0.3; // Ralentir après téléportation
    ball.setInvulnerable(0.5); // Invulnérable brièvement

    // Activer le cooldown
    _cooldown = true;
    _cooldownTimer = GameConstants.teleporterCooldown;
  }

  @override
  void render(Canvas canvas) {
    final isCooling = _cooldown;
    final baseColor = isCooling
        ? const Color(0xFF555577)
        : const Color(0xFFBD00FF);
    final baseOpacity = isCooling ? 0.3 : 1.0;

    // Glow
    canvas.drawCircle(
      Offset.zero,
      radius + 14,
      Paint()
        ..color = baseColor.withOpacity(0.2 * baseOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Vortex particules
    if (!isCooling) {
      for (var p in _vortex) {
        canvas.drawCircle(
          Offset(cos(p.angle) * p.currentRadius, sin(p.angle) * p.currentRadius),
          p.size,
          Paint()
            ..color = const Color(0xFFBD00FF).withOpacity(0.6)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }
    }

    // Anneau externe qui tourne
    canvas.save();
    canvas.rotate(_time * 1.5);
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = baseColor.withOpacity(0.4 * baseOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Points sur l'anneau
    for (int i = 0; i < 3; i++) {
      final angle = (i / 3) * 2 * pi;
      canvas.drawCircle(
        Offset(cos(angle) * radius, sin(angle) * radius),
        3,
        Paint()..color = baseColor.withOpacity(baseOpacity),
      );
    }
    canvas.restore();

    // Centre
    canvas.drawCircle(
      Offset.zero,
      radius * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(baseOpacity),
            baseColor.withOpacity(baseOpacity),
            baseColor.withOpacity(0.3 * baseOpacity),
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius * 0.5)),
    );

    // Indicateur de groupe (numéro)
    _drawGroupId(canvas, baseColor, baseOpacity);
  }

  void _drawGroupId(Canvas canvas, Color color, double opacity) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$groupId',
        style: TextStyle(
          color: Colors.white.withOpacity(opacity * 0.7),
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}

class _VortexParticle {
  double angle;
  final double speed;
  final double radius;
  double currentRadius;
  final double size;

  _VortexParticle({
    required this.angle,
    required this.speed,
    required this.radius,
    required this.size,
  }) : currentRadius = radius;
}