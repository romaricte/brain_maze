import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../levels/level_model.dart';

class Trap extends CircleComponent with CollisionCallbacks {
  double _time = 0;
  final TrapType type;

  // Pour les pièges clignotants
  bool _isActive = true;
  static const double _blinkOnDuration = 2.0;
  static const double _blinkOffDuration = 1.5;

  Trap({required Vector2 position, this.type = TrapType.static})
      : super(
          position: position,
          radius: GameConstants.trapRadius,
          anchor: Anchor.center,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius * 0.8));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (type == TrapType.blinking) {
      final cycleTime = _time % (_blinkOnDuration + _blinkOffDuration);
      _isActive = cycleTime < _blinkOnDuration;
    }
  }

  bool get isActive => _isActive;

  @override
  void render(Canvas canvas) {
    final pulse = (sin(_time * 4) + 1) / 2;

    if (type == TrapType.blinking && !_isActive) {
      // Piège inactif : grisé
      canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..color = const Color(0xFF444444).withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      // Croix grisée
      _drawCross(canvas, Colors.grey.withOpacity(0.3));
      return;
    }

    // Glow rouge pulsant
    canvas.drawCircle(
      Offset.zero,
      radius + 12,
      Paint()
        ..color = const Color(0xFFFF006E).withOpacity(0.15 + pulse * 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // Cercle principal
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFF4444), Color(0xFFFF006E), Color(0xFF880033)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Anneau de danger qui tourne
    canvas.save();
    canvas.rotate(_time * 2);
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4) * 2 * pi;
      canvas.drawCircle(
        Offset(cos(angle) * (radius + 5), sin(angle) * (radius + 5)),
        1.5,
        Paint()..color = const Color(0xFFFF006E).withOpacity(0.6),
      );
    }
    canvas.restore();

    // Croix blanche
    _drawCross(canvas, Colors.white.withOpacity(0.9));
  }

  void _drawCross(Canvas canvas, Color color) {
    final crossPaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const size = 5.0;
    canvas.drawLine(const Offset(-size, -size), const Offset(size, size), crossPaint);
    canvas.drawLine(const Offset(size, -size), const Offset(-size, size), crossPaint);
  }
}