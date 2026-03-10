import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'ball.dart';

class Teleporter extends CircleComponent with CollisionCallbacks {
  final Vector2 targetPosition;
  double _animTime = 0;
  bool _cooldown = false;
  double _cooldownTimer = 0;

  Teleporter({
    required Vector2 position,
    required this.targetPosition,
  }) : super(
          position: position,
          radius: 16,
          anchor: Anchor.center,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _animTime += dt;
    if (_cooldown) {
      _cooldownTimer -= dt;
      if (_cooldownTimer <= 0) _cooldown = false;
    }
  }

  void teleport(Ball ball) {
    if (_cooldown) return;
    ball.position = targetPosition.clone();
    ball.velocity *= 0.5;
    _cooldown = true;
    _cooldownTimer = 1.0;
  }

  @override
  void render(Canvas canvas) {
    final rotation = _animTime * 2;

    // Glow violet
    canvas.drawCircle(
      Offset.zero,
      radius + 12,
      Paint()
        ..color = const Color(0xFFBD00FF).withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Anneaux tournants
    for (int i = 0; i < 3; i++) {
      final angle = rotation + (i * 2 * pi / 3);
      canvas.drawCircle(
        Offset(cos(angle) * radius * 0.6, sin(angle) * radius * 0.6),
        3,
        Paint()..color = const Color(0xFFBD00FF),
      );
    }

    // Cercle principal
    canvas.drawCircle(
      Offset.zero,
      radius * 0.7,
      Paint()
        ..shader = const RadialGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFBD00FF),
            Color(0xFF5500AA),
          ],
          stops: [0.0, 0.4, 1.0],
        ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: radius * 0.7)),
    );

    // Bordure
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = const Color(0xFFBD00FF).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }
}