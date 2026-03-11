import 'package:flame/components.dart';
import 'level_model.dart';

class LevelData {
  // Génération automatique des bordures
  static List<WallData> _borders(double w, double h) => [
    WallData(position: Vector2(0, 0), size: Vector2(w, 1)),
    WallData(position: Vector2(0, h - 1), size: Vector2(w, 1)),
    WallData(position: Vector2(0, 0), size: Vector2(1, h)),
    WallData(position: Vector2(w - 1, 0), size: Vector2(1, h)),
  ];

  static const double _w = 10;
  static const double _h = 16;

  static List<LevelModel> get allLevels => [

    // =============================================
    //  CHAPITRE 1 : INITIATION (Niveaux 1-5)
    //  → Apprendre les contrôles de base
    // =============================================

    LevelModel(
      id: 1,
      name: "Premier Pas",
      difficulty: Difficulty.easy,
      timeLimit: 90,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Glissez votre doigt pour déplacer la balle vers l'arrivée verte !",
      walls: [
        ..._borders(_w, _h),
        // Un seul couloir simple en L
        WallData(position: Vector2(4, 0), size: Vector2(1, 8)),
        WallData(position: Vector2(4, 8), size: Vector2(5, 1)),
      ],
    ),

    LevelModel(
      id: 2,
      name: "Le Serpent",
      difficulty: Difficulty.easy,
      timeLimit: 80,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      hintText: "Suivez le chemin en zigzag.",
      walls: [
        ..._borders(_w, _h),
        // Zigzag horizontal classique
        WallData(position: Vector2(0, 3), size: Vector2(7, 1)),
        WallData(position: Vector2(3, 6), size: Vector2(7, 1)),
        WallData(position: Vector2(0, 9), size: Vector2(7, 1)),
        WallData(position: Vector2(3, 12), size: Vector2(7, 1)),
      ],
    ),

    LevelModel(
      id: 3,
      name: "Le Choix",
      difficulty: Difficulty.easy,
      timeLimit: 75,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(5, 2),
      goalPosition: Vector2(5, 14),
      hintText: "Deux chemins possibles, lequel est le plus rapide ?",
      walls: [
        ..._borders(_w, _h),
        // Mur central qui sépare deux chemins
        WallData(position: Vector2(5, 3), size: Vector2(1, 10)),
        // Obstacles côté gauche (plus court mais étroit)
        WallData(position: Vector2(2, 5), size: Vector2(2, 1)),
        WallData(position: Vector2(2, 9), size: Vector2(2, 1)),
        // Obstacles côté droit (plus long mais facile)
        WallData(position: Vector2(7, 4), size: Vector2(1, 3)),
        WallData(position: Vector2(7, 9), size: Vector2(1, 3)),
        // Ouvertures dans le mur central
        WallData(position: Vector2(3, 13), size: Vector2(4, 1)),
      ],
    ),

    LevelModel(
      id: 4,
      name: "Spirale",
      difficulty: Difficulty.easy,
      timeLimit: 70,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(5, 8),
      goalPosition: Vector2(1, 1),
      hintText: "Déroulez la spirale de l'intérieur vers l'extérieur.",
      walls: [
        ..._borders(_w, _h),
        // Spirale vers l'intérieur
        WallData(position: Vector2(2, 2), size: Vector2(7, 1)),
        WallData(position: Vector2(8, 2), size: Vector2(1, 6)),
        WallData(position: Vector2(2, 4), size: Vector2(1, 5)),
        WallData(position: Vector2(2, 8), size: Vector2(5, 1)),
        WallData(position: Vector2(6, 5), size: Vector2(1, 3)),
        WallData(position: Vector2(4, 5), size: Vector2(2, 1)),
        // Zone basse ouverte
        WallData(position: Vector2(2, 11), size: Vector2(6, 1)),
        WallData(position: Vector2(4, 13), size: Vector2(1, 2)),
      ],
    ),

    LevelModel(
      id: 5,
      name: "L'Arène",
      difficulty: Difficulty.easy,
      timeLimit: 65,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Traversez les salles une par une.",
      walls: [
        ..._borders(_w, _h),
        // 3 salles connectées
        // Salle 1 (haut)
        WallData(position: Vector2(1, 5), size: Vector2(4, 1)),
        WallData(position: Vector2(6, 5), size: Vector2(3, 1)),
        // Salle 2 (milieu)
        WallData(position: Vector2(1, 10), size: Vector2(3, 1)),
        WallData(position: Vector2(5, 10), size: Vector2(4, 1)),
        // Obstacles internes
        WallData(position: Vector2(3, 2), size: Vector2(1, 2)),
        WallData(position: Vector2(6, 7), size: Vector2(1, 2)),
        WallData(position: Vector2(3, 12), size: Vector2(1, 2)),
      ],
    ),

    // =============================================
    //  CHAPITRE 2 : DANGER (Niveaux 6-10)
    //  → Introduction des pièges
    // =============================================

    LevelModel(
      id: 6,
      name: "Terrain Miné",
      difficulty: Difficulty.medium,
      timeLimit: 60,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Attention aux pièges rouges ! Ils vous tuent au contact.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(3, 4), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 6), size: Vector2(1, 5)),
        WallData(position: Vector2(2, 11), size: Vector2(5, 1)),
      ],
      traps: [
        TrapData(position: Vector2(5, 3)),
        TrapData(position: Vector2(2, 7)),
        TrapData(position: Vector2(5, 9)),
        TrapData(position: Vector2(8, 7)),
        TrapData(position: Vector2(4, 13)),
      ],
    ),

    LevelModel(
      id: 7,
      name: "Le Couloir de la Mort",
      difficulty: Difficulty.medium,
      timeLimit: 55,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(8, 2),
      hintText: "Remontez le couloir en évitant les pièges alignés.",
      walls: [
        ..._borders(_w, _h),
        // Couloir central
        WallData(position: Vector2(3, 1), size: Vector2(1, 14)),
        WallData(position: Vector2(7, 1), size: Vector2(1, 14)),
        // Chicanes dans le couloir
        WallData(position: Vector2(4, 3), size: Vector2(2, 1)),
        WallData(position: Vector2(5, 7), size: Vector2(2, 1)),
        WallData(position: Vector2(4, 11), size: Vector2(2, 1)),
      ],
      traps: [
        TrapData(position: Vector2(5, 2)),
        TrapData(position: Vector2(4, 5)),
        TrapData(position: Vector2(6, 5)),
        TrapData(position: Vector2(5, 9)),
        TrapData(position: Vector2(4, 13)),
        TrapData(position: Vector2(6, 13)),
      ],
    ),

    LevelModel(
      id: 8,
      name: "Slalom",
      difficulty: Difficulty.medium,
      timeLimit: 50,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(5, 2),
      hintText: "Slalomez entre les murs tout en évitant les pièges.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(3, 12), size: Vector2(5, 1)),
        WallData(position: Vector2(1, 10), size: Vector2(5, 1)),
        WallData(position: Vector2(4, 8), size: Vector2(5, 1)),
        WallData(position: Vector2(1, 6), size: Vector2(5, 1)),
        WallData(position: Vector2(4, 4), size: Vector2(5, 1)),
      ],
      traps: [
        TrapData(position: Vector2(7, 13)),
        TrapData(position: Vector2(2, 11)),
        TrapData(position: Vector2(8, 9)),
        TrapData(position: Vector2(2, 7)),
        TrapData(position: Vector2(8, 5)),
        TrapData(position: Vector2(2, 3)),
      ],
    ),

    LevelModel(
      id: 9,
      name: "La Croix",
      difficulty: Difficulty.medium,
      timeLimit: 50,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Traversez l'intersection sans toucher les pièges.",
      walls: [
        ..._borders(_w, _h),
        // Croix centrale
        WallData(position: Vector2(1, 7), size: Vector2(3, 1)),
        WallData(position: Vector2(6, 7), size: Vector2(3, 1)),
        WallData(position: Vector2(1, 9), size: Vector2(3, 1)),
        WallData(position: Vector2(6, 9), size: Vector2(3, 1)),
        WallData(position: Vector2(4, 1), size: Vector2(1, 5)),
        WallData(position: Vector2(4, 11), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 1), size: Vector2(1, 5)),
        WallData(position: Vector2(6, 11), size: Vector2(1, 4)),
      ],
      traps: [
        TrapData(position: Vector2(5, 5)),
        TrapData(position: Vector2(5, 11)),
        TrapData(position: Vector2(2, 8)),
        TrapData(position: Vector2(8, 8)),
      ],
    ),

    LevelModel(
      id: 10,
      name: "Piège Mortel",
      difficulty: Difficulty.medium,
      timeLimit: 45,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(5, 14),
      goalPosition: Vector2(5, 2),
      hintText: "Le chemin le plus court n'est pas toujours le plus sûr...",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(3, 3), size: Vector2(1, 5)),
        WallData(position: Vector2(7, 3), size: Vector2(1, 5)),
        WallData(position: Vector2(3, 8), size: Vector2(2, 1)),
        WallData(position: Vector2(6, 8), size: Vector2(2, 1)),
        WallData(position: Vector2(2, 10), size: Vector2(6, 1)),
        WallData(position: Vector2(4, 12), size: Vector2(3, 1)),
      ],
      traps: [
        TrapData(position: Vector2(5, 4)),
        TrapData(position: Vector2(4, 6)),
        TrapData(position: Vector2(6, 6)),
        TrapData(position: Vector2(5, 9)),
        TrapData(position: Vector2(3, 13)),
        TrapData(position: Vector2(7, 13)),
        TrapData(position: Vector2(5, 11)),
      ],
    ),

    // =============================================
    //  CHAPITRE 3 : DIMENSIONS (Niveaux 11-15)
    //  → Introduction des téléporteurs
    // =============================================

    LevelModel(
      id: 11,
      name: "Le Portail",
      difficulty: Difficulty.medium,
      timeLimit: 55,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Les portails violets vous téléportent ! Utilisez-les.",
      walls: [
        ..._borders(_w, _h),
        // Mur infranchissable au milieu
        WallData(position: Vector2(1, 7), size: Vector2(9, 1)),
      ],
      teleporters: [
        TeleporterData(
          positionA: Vector2(8, 4),
          positionB: Vector2(2, 10),
          groupId: 1,
        ),
      ],
    ),

    LevelModel(
      id: 12,
      name: "Double Saut",
      difficulty: Difficulty.medium,
      timeLimit: 50,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(8, 2),
      hintText: "Deux téléporteurs à utiliser dans le bon ordre.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(1, 5), size: Vector2(9, 1)),
        WallData(position: Vector2(1, 10), size: Vector2(9, 1)),
      ],
      teleporters: [
        TeleporterData(
          positionA: Vector2(8, 12),
          positionB: Vector2(2, 8),
          groupId: 1,
        ),
        TeleporterData(
          positionA: Vector2(8, 7),
          positionB: Vector2(2, 3),
          groupId: 2,
        ),
      ],
    ),

    LevelModel(
      id: 13,
      name: "Choix Dimensionnel",
      difficulty: Difficulty.hard,
      timeLimit: 45,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(5, 14),
      goalPosition: Vector2(5, 2),
      hintText: "Un seul téléporteur mène au bon endroit...",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(1, 8), size: Vector2(9, 1)),
        WallData(position: Vector2(3, 10), size: Vector2(1, 5)),
        WallData(position: Vector2(7, 10), size: Vector2(1, 5)),
      ],
      teleporters: [
        // Bon chemin
        TeleporterData(
          positionA: Vector2(5, 12),
          positionB: Vector2(5, 5),
          groupId: 1,
        ),
        // Piège - ramène au début
        TeleporterData(
          positionA: Vector2(2, 12),
          positionB: Vector2(8, 13),
          groupId: 2,
        ),
      ],
      traps: [
        TrapData(position: Vector2(5, 7)),
        TrapData(position: Vector2(3, 5)),
        TrapData(position: Vector2(7, 5)),
      ],
    ),

    LevelModel(
      id: 14,
      name: "Réseau Portal",
      difficulty: Difficulty.hard,
      timeLimit: 45,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 2),
      goalPosition: Vector2(8, 14),
      hintText: "Trouvez la bonne combinaison de téléporteurs.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(1, 4), size: Vector2(5, 1)),
        WallData(position: Vector2(5, 7), size: Vector2(4, 1)),
        WallData(position: Vector2(1, 10), size: Vector2(5, 1)),
        WallData(position: Vector2(5, 13), size: Vector2(4, 1)),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(8, 3), positionB: Vector2(2, 6), groupId: 1),
        TeleporterData(positionA: Vector2(3, 8), positionB: Vector2(8, 9), groupId: 2),
        TeleporterData(positionA: Vector2(8, 11), positionB: Vector2(3, 14), groupId: 3),
      ],
      traps: [
        TrapData(position: Vector2(5, 3)),
        TrapData(position: Vector2(2, 9)),
        TrapData(position: Vector2(6, 12)),
      ],
    ),

    LevelModel(
      id: 15,
      name: "Le Labyrinthe Dimensionnel",
      difficulty: Difficulty.hard,
      timeLimit: 40,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(5, 2),
      hintText: "Combinez tout : murs, pièges et téléporteurs.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(4, 1), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 1), size: Vector2(1, 4)),
        WallData(position: Vector2(1, 5), size: Vector2(3, 1)),
        WallData(position: Vector2(6, 5), size: Vector2(3, 1)),
        WallData(position: Vector2(3, 7), size: Vector2(5, 1)),
        WallData(position: Vector2(1, 9), size: Vector2(4, 1)),
        WallData(position: Vector2(6, 9), size: Vector2(3, 1)),
        WallData(position: Vector2(4, 11), size: Vector2(1, 4)),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(2, 12), positionB: Vector2(2, 6), groupId: 1),
        TeleporterData(positionA: Vector2(8, 6), positionB: Vector2(5, 4), groupId: 2),
      ],
      traps: [
        TrapData(position: Vector2(5, 6)),
        TrapData(position: Vector2(2, 8)),
        TrapData(position: Vector2(8, 8)),
        TrapData(position: Vector2(3, 3)),
        TrapData(position: Vector2(7, 3)),
        TrapData(position: Vector2(6, 13)),
      ],
    ),

    // =============================================
    //  CHAPITRE 4 : MOUVEMENT (Niveaux 16-20)
    //  → Murs mouvants + tout le reste
    // =============================================

    LevelModel(
      id: 16,
      name: "Mur Vivant",
      difficulty: Difficulty.hard,
      timeLimit: 50,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(8, 2),
      hintText: "Les murs orange bougent ! Observez leur rythme.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(3, 4), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 8), size: Vector2(1, 4)),
      ],
      movingWalls: [
        MovingWallData(
          start: Vector2(1, 7),
          end: Vector2(6, 7),
          size: Vector2(2, 1),
          speed: 1.5,
        ),
        MovingWallData(
          start: Vector2(7, 12),
          end: Vector2(2, 12),
          size: Vector2(2, 1),
          speed: 2.0,
        ),
      ],
    ),

    LevelModel(
      id: 17,
      name: "Timing Parfait",
      difficulty: Difficulty.hard,
      timeLimit: 45,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(2, 2),
      hintText: "Attendez le bon moment pour passer !",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(1, 4), size: Vector2(3, 1)),
        WallData(position: Vector2(1, 8), size: Vector2(3, 1)),
        WallData(position: Vector2(1, 12), size: Vector2(3, 1)),
      ],
      movingWalls: [
        MovingWallData(
          start: Vector2(4, 4),
          end: Vector2(8, 4),
          size: Vector2(2, 1),
          speed: 2.5,
          delay: 0,
        ),
        MovingWallData(
          start: Vector2(8, 8),
          end: Vector2(4, 8),
          size: Vector2(2, 1),
          speed: 2.0,
          delay: 0.5,
        ),
        MovingWallData(
          start: Vector2(4, 12),
          end: Vector2(8, 12),
          size: Vector2(2, 1),
          speed: 3.0,
          delay: 1.0,
        ),
      ],
      traps: [
        TrapData(position: Vector2(5, 6)),
        TrapData(position: Vector2(5, 10)),
        TrapData(position: Vector2(5, 2)),
      ],
    ),

    LevelModel(
      id: 18,
      name: "Le Broyeur",
      difficulty: Difficulty.expert,
      timeLimit: 40,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(8, 2),
      hintText: "Des murs qui se rapprochent... Ne vous faites pas écraser !",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(4, 5), size: Vector2(1, 2)),
        WallData(position: Vector2(6, 9), size: Vector2(1, 2)),
      ],
      movingWalls: [
        // Broyeur horizontal 1
        MovingWallData(
          start: Vector2(1, 3),
          end: Vector2(4, 3),
          size: Vector2(3, 1),
          speed: 2.0,
        ),
        MovingWallData(
          start: Vector2(8, 3),
          end: Vector2(5, 3),
          size: Vector2(1, 1),
          speed: 2.0,
        ),
        // Broyeur horizontal 2
        MovingWallData(
          start: Vector2(1, 7),
          end: Vector2(5, 7),
          size: Vector2(2, 1),
          speed: 2.5,
        ),
        MovingWallData(
          start: Vector2(8, 7),
          end: Vector2(5, 7),
          size: Vector2(1, 1),
          speed: 2.5,
        ),
        // Broyeur horizontal 3
        MovingWallData(
          start: Vector2(1, 11),
          end: Vector2(4, 11),
          size: Vector2(2, 1),
          speed: 3.0,
        ),
        MovingWallData(
          start: Vector2(8, 11),
          end: Vector2(5, 11),
          size: Vector2(2, 1),
          speed: 3.0,
        ),
      ],
      traps: [
        TrapData(position: Vector2(5, 5)),
        TrapData(position: Vector2(3, 9)),
        TrapData(position: Vector2(7, 13)),
      ],
    ),

    LevelModel(
      id: 19,
      name: "Chaos Organisé",
      difficulty: Difficulty.expert,
      timeLimit: 40,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(8, 2),
      hintText: "Tout bouge. Restez concentré.",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(4, 2), size: Vector2(1, 3)),
        WallData(position: Vector2(6, 11), size: Vector2(1, 3)),
      ],
      movingWalls: [
        MovingWallData(start: Vector2(1, 4), end: Vector2(7, 4), size: Vector2(2, 1), speed: 2.0),
        MovingWallData(start: Vector2(7, 8), end: Vector2(1, 8), size: Vector2(2, 1), speed: 2.5),
        MovingWallData(start: Vector2(1, 12), end: Vector2(6, 12), size: Vector2(2, 1), speed: 3.0),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(8, 6), positionB: Vector2(2, 10), groupId: 1),
      ],
      traps: [
        TrapData(position: Vector2(3, 6)),
        TrapData(position: Vector2(7, 6)),
        TrapData(position: Vector2(5, 10)),
        TrapData(position: Vector2(3, 13)),
        TrapData(position: Vector2(6, 3)),
      ],
    ),

    LevelModel(
      id: 20,
      name: "Le Boss Final",
      difficulty: Difficulty.expert,
      timeLimit: 35,
      gridSize: Vector2(_w, _h),
      startPosition: Vector2(2, 14),
      goalPosition: Vector2(5, 2),
      hintText: "Combinaison ultime. Bonne chance !",
      walls: [
        ..._borders(_w, _h),
        WallData(position: Vector2(3, 3), size: Vector2(1, 3)),
        WallData(position: Vector2(7, 3), size: Vector2(1, 3)),
        WallData(position: Vector2(1, 6), size: Vector2(3, 1)),
        WallData(position: Vector2(6, 6), size: Vector2(3, 1)),
        WallData(position: Vector2(4, 8), size: Vector2(3, 1)),
        WallData(position: Vector2(2, 10), size: Vector2(2, 1)),
        WallData(position: Vector2(7, 10), size: Vector2(2, 1)),
        WallData(position: Vector2(3, 12), size: Vector2(5, 1)),
      ],
      movingWalls: [
        MovingWallData(start: Vector2(4, 6), end: Vector2(5, 6), size: Vector2(1, 1), speed: 3.0),
        MovingWallData(start: Vector2(1, 10), end: Vector2(4, 10), size: Vector2(1, 1), speed: 2.5),
        MovingWallData(start: Vector2(8, 10), end: Vector2(5, 10), size: Vector2(1, 1), speed: 2.5),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(2, 13), positionB: Vector2(2, 8), groupId: 1),
        TeleporterData(positionA: Vector2(8, 7), positionB: Vector2(5, 4), groupId: 2),
      ],
      traps: [
        TrapData(position: Vector2(5, 5)),
        TrapData(position: Vector2(3, 7)),
        TrapData(position: Vector2(7, 7)),
        TrapData(position: Vector2(5, 9)),
        TrapData(position: Vector2(4, 11)),
        TrapData(position: Vector2(6, 11)),
        TrapData(position: Vector2(5, 13)),
        TrapData(position: Vector2(8, 13)),
      ],
    ),
  ];
}