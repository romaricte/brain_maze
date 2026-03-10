import 'package:flutter/material.dart';
import '../core/theme.dart';

class StarDisplay extends StatelessWidget {
  final int starCount; // 0, 1, 2, ou 3
  final double size;

  const StarDisplay({
    super.key,
    required this.starCount,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < starCount ? Icons.star_rounded : Icons.star_outline_rounded,
            color: index < starCount ? AppColors.starGold : AppColors.textSecondary,
            size: size,
          ),
        );
      }),
    );
  }
}