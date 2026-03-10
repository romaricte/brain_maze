import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wall extends RectangleComponent with CollisionCallbacks {
  Wall({
    required Vector2 position,
    required Vector2 size,
  }) : super(
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
    // Fond du mur
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Mur avec dégradé
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A5A),
            Color(0xFF1A1A3E),
          ],
        ).createShader(rect),
    );

    // Bordure lumineuse
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFF4A4A8A).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Lueur sur les bords
    canvas.drawRect(
      rect.deflate(1),
      Paint()
        ..color = const Color(0xFF6A6ABA).withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }
}