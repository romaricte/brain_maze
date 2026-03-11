class GameConstants {
  // Grille
  static const int gridWidth = 10;
  static const int gridHeight = 16;

  // Physique
  static const double ballRadius = 10.0;
  static const double maxSpeed = 300.0;
  static const double friction = 0.96;
  static const double bounceFactor = 0.4;
  static const double minVelocity = 2.0;
  static const double accelerometerSensitivity = 12.0;
  static const double swipeSensitivity = 18.0;

  // Gameplay
  static const double trapRadius = 12.0;
  static const double goalRadius = 16.0;
  static const double teleporterRadius = 14.0;
  static const double teleporterCooldown = 1.2;

  // Étoiles
  static const double threeStarThreshold = 0.40; // < 40% du temps
  static const double twoStarThreshold = 0.65;   // < 65% du temps

  // Animation
  static const double pulseSpeed = 3.0;
  static const int maxTrailLength = 20;
  static const double trailFadeRate = 0.7;
}