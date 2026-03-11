import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MovingWall extends RectangleComponent with CollisionCallbacks {
  final Vector2 startPos;
  final Vector2 endPos;
  final double speed;
  final double delay;
  double _progress = 0;
  double _direction = 1; // 1 = forward, -1 = backward
  double _delayTimer;
  bool _started = false;
  double _time = 0;

  // Position précédente pour calculer la vélocité du mur
  Vector2 previousPosition = Vector2.zero();

  MovingWall({
    required this.startPos,
    required this.endPos,
    required Vector2 size,
    required this.speed,
    this.delay = 0,
  })  : _delayTimer = delay,
        super(
          position: startPos.clone(),
          size: size,
          anchor: Anchor.topLeft,
          priority: 6,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    previousPosition = position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    // Gérer le délai initial
    if (!_started) {
      _delayTimer -= dt;
      if (_delayTimer <= 0) {
        _started = true;
      } else {
        return;
      }
    }

    previousPosition = position.clone();

    // Mouvement avec easing (sinusoidal pour un mouvement naturel)
    _progress += dt * speed * 0.08 * _direction;

    if (_progress >= 1.0) {
      _progress = 1.0;
      _direction = -1;
    } else if (_progress <= 0.0) {
      _progress = 0.0;
      _direction = 1;
    }

    // Easing sinusoidal
    final easedProgress = (1 - cos(_progress * pi)) / 2;
    position = startPos + (endPos - startPos) * easedProgress;
  }

  Vector2 get wallVelocity => position - previousPosition;

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final dangerPulse = (sin(_time * 3) + 1) / 2;

    // Glow de danger
    canvas.drawRect(
      rect.inflate(4),
      Paint()
        ..color = const Color(0xFFFF6B35).withOpacity(0.2 + dangerPulse * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Fond dégradé orange
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8844), Color(0xFFCC4400)],
        ).createShader(rect),
    );

    // Motif de danger (rayures diagonales)
    canvas.save();
    canvas.clipRect(rect);
    final stripePaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.2)
      ..strokeWidth = 3;

    for (double i = -size.y; i < size.x + size.y; i += 8) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.y, size.y),
        stripePaint,
      );
    }
    canvas.restore();

    // Bordure
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFFFAA66)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Flèche directionnelle (indique le sens du mouvement)
    _drawDirectionArrow(canvas);
  }

  void _drawDirectionArrow(Canvas canvas) {
    final dir = (endPos - startPos);
    if (dir.length == 0) return;

    final normalized = dir.normalized();
    final arrowDir = _direction > 0 ? normalized : -normalized;
    final center = Offset(size.x / 2, size.y / 2);

    final arrowPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final arrowLength = min(size.x, size.y) * 0.3;
    final tipX = center.dx + arrowDir.x * arrowLength;
    final tipY = center.dy + arrowDir.y * arrowLength;

    canvas.drawLine(
      Offset(center.dx - arrowDir.x * arrowLength, center.dy - arrowDir.y * arrowLength),
      Offset(tipX, tipY),
      arrowPaint,
    );
  }
}