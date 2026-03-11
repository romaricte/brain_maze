import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wall extends RectangleComponent with CollisionCallbacks {
  Wall({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
          priority: 5,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Fond principal
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A5A), Color(0xFF1A1A3E)],
        ).createShader(rect),
    );

    // Bordure lumineuse subtile
    final borderPaint = Paint()
      ..color = const Color(0xFF4A4A8A).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRect(rect, borderPaint);

    // Effet 3D : ombre en bas à droite
    canvas.drawLine(
      Offset(0, size.y),
      Offset(size.x, size.y),
      Paint()
        ..color = const Color(0xFF000020).withOpacity(0.4)
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      Offset(size.x, 0),
      Offset(size.x, size.y),
      Paint()
        ..color = const Color(0xFF000020).withOpacity(0.4)
        ..strokeWidth = 2,
    );

    // Effet 3D : lumière en haut à gauche
    canvas.drawLine(
      Offset.zero,
      Offset(size.x, 0),
      Paint()
        ..color = const Color(0xFF6A6ABA).withOpacity(0.2)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset.zero,
      Offset(0, size.y),
      Paint()
        ..color = const Color(0xFF6A6ABA).withOpacity(0.2)
        ..strokeWidth = 1,
    );
  }
}