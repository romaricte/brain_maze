import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Trap extends CircleComponent with CollisionCallbacks {
  double _animTime = 0;

  Trap({required Vector2 position})
      : super(
          position: position,
          radius: 14,
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
  }

  @override
  void render(Canvas canvas) {
    final pulse = (sin(_animTime * 4) + 1) / 2;

    // Glow rouge
    canvas.drawCircle(
      Offset.zero,
      radius + 10,
      Paint()
        ..color = const Color(0xFFFF006E).withOpacity(0.2 + pulse * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Cercle principal
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [
            Color(0xFFFF4444),
            Color(0xFFFF006E),
            Color(0xFF880033),
          ],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Croix au centre
    final crossPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(-6, -6), const Offset(6, 6), crossPaint);
    canvas.drawLine(const Offset(6, -6), const Offset(-6, 6), crossPaint);
  }
}