import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class Goal extends CircleComponent with CollisionCallbacks {
  double _time = 0;
  final List<_GoalParticle> _particles = [];

  Goal({required Vector2 position})
      : super(
          position: position,
          radius: GameConstants.goalRadius,
          anchor: Anchor.center,
          priority: 5,
        ) {
    // Générer des particules orbitales
    final random = Random();
    for (int i = 0; i < 6; i++) {
      _particles.add(_GoalParticle(
        angle: random.nextDouble() * 2 * pi,
        speed: 1.5 + random.nextDouble() * 1.5,
        distance: radius + 8 + random.nextDouble() * 10,
        size: 1.5 + random.nextDouble() * 2,
      ));
    }
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox(radius: radius * 0.9));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    for (var p in _particles) {
      p.angle += dt * p.speed;
    }
  }

  @override
  void render(Canvas canvas) {
    final pulse = (sin(_time * GameConstants.pulseSpeed) + 1) / 2;

    // Glow pulsant
    canvas.drawCircle(
      Offset.zero,
      radius + 18 + pulse * 8,
      Paint()
        ..color = const Color(0xFF00FF87).withOpacity(0.08 + pulse * 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );

    // Particules orbitales
    for (var p in _particles) {
      canvas.drawCircle(
        Offset(cos(p.angle) * p.distance, sin(p.angle) * p.distance),
        p.size,
        Paint()
          ..color = const Color(0xFF00FF87).withOpacity(0.7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }

    // Anneau externe
    canvas.drawCircle(
      Offset.zero,
      radius + 4,
      Paint()
        ..color = const Color(0xFF00FF87).withOpacity(0.25 + pulse * 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Cercle principal
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF00FF87), Color(0xFF00AA55)],
          stops: [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    // Étoile au centre (tourne)
    _drawRotatingStar(canvas, pulse);

    // Reflet
    canvas.drawCircle(
      const Offset(-4, -4),
      radius * 0.2,
      Paint()..color = Colors.white.withOpacity(0.6),
    );
  }

  void _drawRotatingStar(Canvas canvas, double pulse) {
    canvas.save();
    canvas.rotate(_time * 0.5);

    final starSize = 5.0 + pulse * 2;
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * pi / 180;

      if (i == 0) {
        path.moveTo(cos(outerAngle) * starSize, sin(outerAngle) * starSize);
      } else {
        path.lineTo(cos(outerAngle) * starSize, sin(outerAngle) * starSize);
      }
      path.lineTo(
        cos(innerAngle) * starSize * 0.4,
        sin(innerAngle) * starSize * 0.4,
      );
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.restore();
  }
}

class _GoalParticle {
  double angle;
  final double speed;
  final double distance;
  final double size;

  _GoalParticle({
    required this.angle,
    required this.speed,
    required this.distance,
    required this.size,
  });
}