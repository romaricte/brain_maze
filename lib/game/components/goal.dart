import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Goal extends CircleComponent with CollisionCallbacks {
  double _pulseTime = 0;
  final double _pulseSpeed = 3.0;

  Goal({required Vector2 position})
      : super(
          position: position,
          radius: 18,
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
    _pulseTime += dt * _pulseSpeed;
  }

  @override
  void render(Canvas canvas) {
    final pulse = (sin(_pulseTime) + 1) / 2; // 0 to 1

    // Glow externe pulsant
    canvas.drawCircle(
      Offset.zero,
      radius + 15 + pulse * 8,
      Paint()
        ..color = const Color(0xFF00FF87).withOpacity(0.1 + pulse * 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    // Anneau externe
    canvas.drawCircle(
      Offset.zero,
      radius + 5,
      Paint()
        ..color = const Color(0xFF00FF87).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Cercle principal
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFF00FF87),
            Color(0xFF00AA55),
          ],
          stops: [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Étoile au centre
    _drawStar(canvas, pulse);
  }

  void _drawStar(Canvas canvas, double pulse) {
    final starPaint = Paint()..color = Colors.white.withOpacity(0.9);
    final starSize = 6.0 + pulse * 2;
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;

      if (i == 0) {
        path.moveTo(cos(angle) * starSize, sin(angle) * starSize);
      } else {
        path.lineTo(cos(angle) * starSize, sin(angle) * starSize);
      }
      path.lineTo(
        cos(innerAngle) * starSize * 0.4,
        sin(innerAngle) * starSize * 0.4,
      );
    }
    path.close();
    canvas.drawPath(path, starPaint);
  }
}