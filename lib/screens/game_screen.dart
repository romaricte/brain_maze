import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';
import '../core/theme.dart';
import '../game/brain_maze_game.dart';
import 'package:brain_maze/levels/level_data.dart';
import 'package:brain_maze/levels/level_model.dart';
import 'package:brain_maze/services/storage_service.dart';
// import 'package:brain_maze/services/ad_service.dart';
import '../widgets/star_display.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BrainMazeGame _game;
  final _storage = StorageService();
  int _timeRemaining = 0;
  bool _showOverlay = false;
  String _overlayType = ''; // 'win', 'lose', 'pause'
  int _earnedStars = 0;

  @override
  void initState() {
    super.initState();
    final level = LevelData.allLevels.firstWhere((l) => l.id == widget.levelId);
    _timeRemaining = level.timeLimit;

    _game = BrainMazeGame(
      levelId: widget.levelId,
      onWin: _onWin,
      onLose: _onLose,
      onTimeUpdate: (time) => setState(() => _timeRemaining = time),
      useAccelerometer: _storage.getUseAccelerometer(),
    );
  }

  void _onWin(int stars, double time) {
    _earnedStars = stars;
    _storage.saveStars(widget.levelId, stars);
    _storage.saveBestTime(widget.levelId, time);

    // Afficher pub tous les 3 niveaux
      // if (widget.levelId % 3 == 0) {
      //   AdService.showInterstitial();
      // }

    setState(() {
      _showOverlay = true;
      _overlayType = 'win';
    });

    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  void _onLose() {
    setState(() {
      _showOverlay = true;
      _overlayType = 'lose';
    });

    Vibration.vibrate(pattern: [0, 50, 100, 50], intensities: [128, 255]);
  }

  @override
  Widget build(BuildContext context) {
    final level = LevelData.allLevels.firstWhere((l) => l.id == widget.levelId);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // Le jeu Flame
            GameWidget(game: _game),

            // HUD en haut
            _buildHUD(level),

            // Overlay (win/lose/pause)
            if (_showOverlay) _buildOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHUD(dynamic level) {
    final isTimeWarning = _timeRemaining <= 10;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Pause
            _hudButton(Icons.pause_rounded, () {
              _game.togglePause();
              setState(() {
                _showOverlay = true;
                _overlayType = 'pause';
              });
            }),

            // Infos niveau
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "NIVEAU ${level.id}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  level.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.neonBlue,
                  ),
                ),
              ],
            ),

            // Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isTimeWarning
                    ? AppColors.neonPink.withOpacity(0.2)
                    : AppColors.surface.withOpacity(0.8),
                border: Border.all(
                  color: isTimeWarning
                      ? AppColors.neonPink
                      : AppColors.neonBlue.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: isTimeWarning ? AppColors.neonPink : AppColors.neonBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${_timeRemaining}s",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isTimeWarning
                          ? AppColors.neonPink
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hudButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface.withOpacity(0.8),
          border: Border.all(
            color: AppColors.neonBlue.withOpacity(0.3),
          ),
        ),
        child: Icon(icon, color: AppColors.neonBlue, size: 22),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surface,
            border: Border.all(
              color: _overlayType == 'win'
                  ? AppColors.neonGreen
                  : _overlayType == 'lose'
                      ? AppColors.neonPink
                      : AppColors.neonBlue,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (_overlayType == 'win'
                        ? AppColors.neonGreen
                        : _overlayType == 'lose'
                            ? AppColors.neonPink
                            : AppColors.neonBlue)
                    .withOpacity(0.3),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre
              Text(
                _overlayType == 'win'
                    ? "🎉 VICTOIRE !"
                    : _overlayType == 'lose'
                        ? "💀 PERDU !"
                        : "⏸️ PAUSE",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _overlayType == 'win'
                      ? AppColors.neonGreen
                      : _overlayType == 'lose'
                          ? AppColors.neonPink
                          : AppColors.neonBlue,
                ),
              ),
              const SizedBox(height: 20),

              // Étoiles (si victoire)
              if (_overlayType == 'win') ...[
                StarDisplay(starCount: _earnedStars, size: 40),
                const SizedBox(height: 12),
                Text(
                  _earnedStars == 3
                      ? "PARFAIT !"
                      : _earnedStars == 2
                          ? "Bien joué !"
                          : "Terminé !",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Boutons
              if (_overlayType == 'win') ...[
                _overlayButton(
                  "NIVEAU SUIVANT",
                  AppColors.neonGreen,
                  () {
                    final nextId = widget.levelId + 1;
                    if (nextId <= LevelData.allLevels.length) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(levelId: nextId),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],

              _overlayButton(
                "RECOMMENCER",
                AppColors.neonYellow,
                () {
                  _game.restartLevel();
                  setState(() => _showOverlay = false);
                },
              ),
              const SizedBox(height: 12),

              if (_overlayType == 'pause')
                _overlayButton(
                  "REPRENDRE",
                  AppColors.neonGreen,
                  () {
                    _game.togglePause();
                    setState(() => _showOverlay = false);
                  },
                ),

              const SizedBox(height: 12),

              _overlayButton(
                "MENU",
                AppColors.neonPink,
                () => Navigator.pop(context),
              ),
            ],
          ),
        ).animate().scaleXY(begin: 0.8, end: 1, duration: 300.ms).fadeIn(),
      ),
    );
  }

  Widget _overlayButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
          color: color.withOpacity(0.1),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}