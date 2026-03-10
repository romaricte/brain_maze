import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color glowColor;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 250,
    this.height = 60,
    this.glowColor = AppColors.neonBlue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: glowColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: glowColor.withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              glowColor.withOpacity(0.2),
              glowColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: glowColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              shadows: [
                Shadow(color: glowColor, blurRadius: 10),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 2000.ms, color: glowColor.withOpacity(0.3));
  }
}