import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Collectible extends CircleComponent with CollisionCallbacks {
  final int points;
  double _time = 0;
  bool _collected = false;
  double _collectAnim = 0;

  Collectible({required Vector2 position, this.points = 100})
      : super(
          position: position,
          radius: 10,
          anchor: Anchor.center,
          priority: 7,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius * 0.8));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    if (_collected) {
      _collectAnim += dt * 4;
      if (_collectAnim >= 1.0) {
        removeFromParent();
      }
    }
  }

  void collect() {
    if (_collected) return;
    _collected = true;
    _collectAnim = 0;
  }

  @override
  void render(Canvas canvas) {
    if (_collected) {
      _renderCollectAnimation(canvas);
      return;
    }

    final float = sin(_time * 3) * 3;
    final pulse = (sin(_time * 4) + 1) / 2;

    canvas.save();
    canvas.translate(0, float);

    // Glow
    canvas.drawCircle(
      Offset.zero,
      radius + 8,
      Paint()
        ..color = const Color(0xFFFFD700).withOpacity(0.2 + pulse * 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Diamant
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFFD700), Color(0xFFCC8800)],
          stops: [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Reflet
    canvas.drawCircle(
      const Offset(-2, -3),
      radius * 0.25,
      Paint()..color = Colors.white.withOpacity(0.8),
    );

    canvas.restore();
  }

  void _renderCollectAnimation(Canvas canvas) {
    final progress = _collectAnim.clamp(0.0, 1.0);
    final scale = 1.0 + progress * 1.5;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    // Expansion + fadeout
    canvas.drawCircle(
      Offset.zero,
      radius * scale,
      Paint()
        ..color = const Color(0xFFFFD700).withOpacity(opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Texte "+100" qui monte
    final textPainter = TextPainter(
      text: TextSpan(
        text: '+$points',
        style: TextStyle(
          color: const Color(0xFFFFD700).withOpacity(opacity),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -20 - progress * 30),
    );
  }
}