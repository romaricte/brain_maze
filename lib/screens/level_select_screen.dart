import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import 'package:brain_maze/levels/level_data.dart';
import 'package:brain_maze/services/storage_service.dart';
import '../widgets/star_display.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final levels = LevelData.allLevels;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: AppColors.neonBlue),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "NIVEAUX",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Grille de niveaux
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final level = levels[index];
                    final isUnlocked = _isLevelUnlocked(level.id);
                    final stars = _storage.getStars(level.id);

                    return _buildLevelCard(level, isUnlocked, stars, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLevelUnlocked(int levelId) {
    if (levelId == 1) return true;
    return _storage.getStars(levelId - 1) > 0;
  }

  Widget _buildLevelCard(
      dynamic level, bool isUnlocked, int stars, int index) {
    final difficultyColor = switch (level.difficulty) {
      1 => AppColors.easy,
      2 => AppColors.medium,
      3 => AppColors.hard,
      _ => AppColors.easy,
    };

    return GestureDetector(
      onTap: isUnlocked
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(levelId: level.id),
                ),
              ).then((_) => setState(() {}))
          : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isUnlocked
              ? AppColors.surface
              : AppColors.surface.withOpacity(0.3),
          border: Border.all(
            color: isUnlocked
                ? difficultyColor.withOpacity(0.5)
                : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: difficultyColor.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              Icon(
                Icons.lock_rounded,
                color: Colors.grey.withOpacity(0.4),
                size: 32,
              )
            else ...[
              Text(
                "${level.id}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: difficultyColor,
                  shadows: [
                    Shadow(
                      color: difficultyColor.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level.name,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              StarDisplay(starCount: stars, size: 18),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (50 * index).ms)
        .scaleXY(begin: 0.8, end: 1.0, duration: 400.ms, delay: (50 * index).ms);
  }
}