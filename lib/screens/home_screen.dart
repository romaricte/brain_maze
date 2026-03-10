import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../widgets/neon_button.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo / Titre
                _buildTitle(),

                const Spacer(flex: 1),

                // Balle animée décorative
                _buildAnimatedBall(),

                const Spacer(flex: 1),

                // Boutons
                NeonButton(
                  text: "JOUER",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LevelSelectScreen(),
                    ),
                  ),
                  glowColor: AppColors.neonGreen,
                ),

                const SizedBox(height: 20),

                NeonButton(
                  text: "PARAMÈTRES",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  ),
                  glowColor: AppColors.neonBlue,
                  width: 220,
                  height: 50,
                ),

                const Spacer(flex: 2),

                // Version
                Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          "BRAIN",
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            color: AppColors.neonBlue,
            letterSpacing: 12,
            shadows: [
              Shadow(color: AppColors.neonBlue.withOpacity(0.8), blurRadius: 20),
              Shadow(color: AppColors.neonBlue.withOpacity(0.4), blurRadius: 40),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: -0.3, end: 0),
        Text(
          "MAZE",
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w900,
            color: AppColors.neonPink,
            letterSpacing: 16,
            shadows: [
              Shadow(color: AppColors.neonPink.withOpacity(0.8), blurRadius: 20),
              Shadow(color: AppColors.neonPink.withOpacity(0.4), blurRadius: 40),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        Text(
          "⚡ PUZZLE CHALLENGE ⚡",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.neonYellow.withOpacity(0.8),
            letterSpacing: 4,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .fade(begin: 0.5, end: 1.0, duration: 1500.ms),
      ],
    );
  }

  Widget _buildAnimatedBall() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Colors.white, AppColors.neonBlue, Color(0xFF0044AA)],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withOpacity(0.6),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: -15, end: 15, duration: 1500.ms, curve: Curves.easeInOut)
        .scaleXY(begin: 0.9, end: 1.1, duration: 1500.ms);
  }
}