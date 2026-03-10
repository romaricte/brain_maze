import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class MovingWall extends RectangleComponent with CollisionCallbacks {
  final Vector2 startPos;
  final Vector2 endPos;
  final double speed;
  double _progress = 0;
  bool _forward = true;

  MovingWall({
    required this.startPos,
    required this.endPos,
    required Vector2 size,
    required this.speed,
  }) : super(
          position: startPos.clone(),
          size: size,
          anchor: Anchor.topLeft,
          priority: 6,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_forward) {
      _progress += dt * speed * 0.1;
      if (_progress >= 1) {
        _progress = 1;
        _forward = false;
      }
    } else {
      _progress -= dt * speed * 0.1;
      if (_progress <= 0) {
        _progress = 0;
        _forward = true;
      }
    }

    position = startPos + (endPos - startPos) * _progress;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Mur avec couleur orange/danger
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFCC4400)],
        ).createShader(rect),
    );

    // Glow
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFFF6B35).withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Bordure
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFFFF9966)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}