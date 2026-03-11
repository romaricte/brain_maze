import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../core/theme.dart';
import '../game/brain_maze_game.dart';
import '../game/levels/level_data.dart';
import '../game/levels/level_model.dart';
import '../services/storage_service.dart';
// import '../services/ad_service.dart';
import '../widgets/star_display.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late BrainMazeGame _game;
  final _storage = StorageService();

  int _timeRemaining = 0;
  int _score = 0;
  bool _showOverlay = false;
  String _overlayType = '';
  int _earnedStars = 0;
  double _completionTime = 0;

  @override
  void initState() {
    super.initState();
    final level = LevelData.allLevels.firstWhere((l) => l.id == widget.levelId);
    _timeRemaining = level.timeLimit;

    _game = BrainMazeGame(
      levelId: widget.levelId,
      onWin: _onWin,
      onLose: _onLose,
      onTimeUpdate: (time) {
        if (mounted) setState(() => _timeRemaining = time);
      },
      onScoreUpdate: (score) {
        if (mounted) setState(() => _score = score);
      },
      useAccelerometer: _storage.getUseAccelerometer(),
    );
  }

  void _onWin(int stars, double time, int score) {
    _earnedStars = stars;
    _completionTime = time;
    _score = score;

    _storage.saveStars(widget.levelId, stars);
    _storage.saveBestTime(widget.levelId, time);

    // if (widget.levelId % 3 == 0) {
    //   AdService.showInterstitial();
    // }

    if (mounted) {
      setState(() {
        _showOverlay = true;
        _overlayType = 'win';
      });
    }

    if (_storage.getVibrationEnabled()) {
      Vibration.vibrate(duration: 100, amplitude: 128);
    }
  }

  void _onLose() {
    if (mounted) {
      setState(() {
        _showOverlay = true;
        _overlayType = 'lose';
      });
    }

    if (_storage.getVibrationEnabled()) {
      Vibration.vibrate(pattern: [0, 50, 100, 50]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = LevelData.allLevels.firstWhere((l) => l.id == widget.levelId);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Stack(
          children: [
            // Le jeu
            GameWidget(game: _game),

            // HUD
            _buildHUD(level),

            // Hint initial
            if (_game.state == GameState.countdown && level.hintText != null)
              _buildHintBanner(level.hintText!),

            // Overlay
            if (_showOverlay) _buildOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHintBanner(String hint) {
    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface.withOpacity(0.9),
          border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: AppColors.neonYellow, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildHUD(LevelModel level) {
    final isTimeWarning = _timeRemaining <= 10;
    final isTimeCritical = _timeRemaining <= 5;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Pause
                _hudButton(Icons.pause_rounded, () {
                  _game.togglePause();
                  setState(() {
                    _showOverlay = true;
                    _overlayType = 'pause';
                  });
                }),

                // Info niveau + Score
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "NIVEAU ${level.id}",
                      style: TextStyle(
                        fontSize: 13,
                        color: level.difficultyColor.withOpacity(0.8),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      level.name.toUpperCase(),
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    if (_score > 0)
                      Text(
                        "Score: $_score",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.starGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),

                // Timer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isTimeCritical
                        ? AppColors.neonPink.withOpacity(0.25)
                        : isTimeWarning
                            ? AppColors.neonYellow.withOpacity(0.15)
                            : AppColors.surface.withOpacity(0.8),
                    border: Border.all(
                      color: isTimeCritical
                          ? AppColors.neonPink
                          : isTimeWarning
                              ? AppColors.neonYellow
                              : AppColors.neonBlue.withOpacity(0.3),
                      width: isTimeCritical ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: isTimeCritical
                            ? AppColors.neonPink
                            : isTimeWarning
                                ? AppColors.neonYellow
                                : AppColors.neonBlue,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${_timeRemaining}s",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isTimeCritical
                              ? AppColors.neonPink
                              : isTimeWarning
                                  ? AppColors.neonYellow
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Barre de progression du temps
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_timeRemaining / level.timeLimit).clamp(0.0, 1.0),
                backgroundColor: AppColors.surface.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isTimeCritical
                      ? AppColors.neonPink
                      : isTimeWarning
                          ? AppColors.neonYellow
                          : AppColors.neonBlue,
                ),
                minHeight: 3,
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface.withOpacity(0.8),
          border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
        ),
        child: Icon(icon, color: AppColors.neonBlue, size: 20),
      ),
    );
  }

  Widget _buildOverlay() {
    final accentColor = _overlayType == 'win'
        ? AppColors.neonGreen
        : _overlayType == 'lose'
            ? AppColors.neonPink
            : AppColors.neonBlue;

    return GestureDetector(
      onTap: () {}, // Bloque les taps en dessous
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(28),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.surface,
              border: Border.all(color: accentColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(0.15),
                    border: Border.all(color: accentColor.withOpacity(0.5)),
                  ),
                  child: Icon(
                    _overlayType == 'win'
                        ? Icons.emoji_events_rounded
                        : _overlayType == 'lose'
                            ? Icons.close_rounded
                            : Icons.pause_rounded,
                    color: accentColor,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                // Titre
                Text(
                  _overlayType == 'win'
                      ? "VICTOIRE !"
                      : _overlayType == 'lose'
                          ? "PERDU !"
                          : "PAUSE",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 3,
                  ),
                ),

                // Détails victoire
                if (_overlayType == 'win') ...[
                  const SizedBox(height: 16),
                  StarDisplay(starCount: _earnedStars, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    _earnedStars == 3
                        ? "⚡ PARFAIT ! ⚡"
                        : _earnedStars == 2
                            ? "Bien joué !"
                            : "Terminé !",
                    style: TextStyle(
                      color: _earnedStars == 3
                          ? AppColors.starGold
                          : AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Stats
                  _statRow("Temps", "${_completionTime.toStringAsFixed(1)}s"),
                  _statRow("Score", "$_score"),
                  _statRow("Meilleur", "${_storage.getBestTime(widget.levelId).toStringAsFixed(1)}s"),
                ],

                if (_overlayType == 'lose') ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Réessayez !",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],

                const SizedBox(height: 24),

                // Boutons
                if (_overlayType == 'win')
                  _overlayButton("SUIVANT →", AppColors.neonGreen, () {
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
                  }),

                if (_overlayType == 'win') const SizedBox(height: 10),

                _overlayButton("RECOMMENCER", AppColors.neonYellow, () {
                  _game.restartLevel();
                  setState(() {
                    _showOverlay = false;
                    _timeRemaining = _game.level.timeLimit;
                    _score = 0;
                  });
                }),

                if (_overlayType == 'pause') ...[
                  const SizedBox(height: 10),
                  _overlayButton("REPRENDRE", AppColors.neonGreen, () {
                    _game.togglePause();
                    setState(() => _showOverlay = false);
                  }),
                ],

                const SizedBox(height: 10),

                _overlayButton("MENU", AppColors.neonPink.withOpacity(0.7), () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ).animate().scaleXY(begin: 0.85, end: 1, duration: 250.ms, curve: Curves.easeOut).fadeIn(duration: 200.ms),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overlayButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}