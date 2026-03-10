import 'package:flame/components.dart';
import 'level_model.dart';

class LevelData {
  static List<LevelModel> get allLevels => [
    // ========== EASY (1-10) ==========
    LevelModel(
      id: 1,
      name: "Premier Pas",
      difficulty: 1,
      timeLimit: 60,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      walls: [
        // Bordures
        ..._generateBorders(10, 16),
        // Murs internes simples
        WallData(position: Vector2(3, 3), size: Vector2(1, 5)),
        WallData(position: Vector2(6, 2), size: Vector2(1, 4)),
        WallData(position: Vector2(2, 9), size: Vector2(5, 1)),
        WallData(position: Vector2(5, 12), size: Vector2(1, 3)),
      ],
    ),

    LevelModel(
      id: 2,
      name: "Le Serpent",
      difficulty: 1,
      timeLimit: 60,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(0, 3), size: Vector2(7, 1)),
        WallData(position: Vector2(3, 6), size: Vector2(7, 1)),
        WallData(position: Vector2(0, 9), size: Vector2(7, 1)),
        WallData(position: Vector2(3, 12), size: Vector2(7, 1)),
      ],
    ),

    LevelModel(
      id: 3,
      name: "Choix Multiples",
      difficulty: 1,
      timeLimit: 55,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(5, 1),
      goalPosition: Vector2(5, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(2, 3), size: Vector2(1, 4)),
        WallData(position: Vector2(4, 2), size: Vector2(1, 6)),
        WallData(position: Vector2(6, 4), size: Vector2(1, 4)),
        WallData(position: Vector2(8, 2), size: Vector2(1, 5)),
        WallData(position: Vector2(1, 8), size: Vector2(3, 1)),
        WallData(position: Vector2(5, 9), size: Vector2(4, 1)),
        WallData(position: Vector2(3, 11), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 11), size: Vector2(1, 3)),
      ],
    ),

    LevelModel(
      id: 4,
      name: "Spirale",
      difficulty: 1,
      timeLimit: 50,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(5, 8),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(2, 2), size: Vector2(7, 1)),
        WallData(position: Vector2(8, 2), size: Vector2(1, 5)),
        WallData(position: Vector2(2, 4), size: Vector2(1, 4)),
        WallData(position: Vector2(2, 7), size: Vector2(5, 1)),
        WallData(position: Vector2(6, 5), size: Vector2(1, 2)),
        WallData(position: Vector2(4, 5), size: Vector2(2, 1)),
        WallData(position: Vector2(2, 10), size: Vector2(6, 1)),
        WallData(position: Vector2(4, 12), size: Vector2(1, 3)),
      ],
    ),

    LevelModel(
      id: 5,
      name: "Zigzag",
      difficulty: 1,
      timeLimit: 50,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 14),
      goalPosition: Vector2(8, 1),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(2, 13), size: Vector2(6, 1)),
        WallData(position: Vector2(2, 11), size: Vector2(6, 1)),
        WallData(position: Vector2(2, 9), size: Vector2(6, 1)),
        WallData(position: Vector2(2, 7), size: Vector2(6, 1)),
        WallData(position: Vector2(2, 5), size: Vector2(6, 1)),
        WallData(position: Vector2(2, 3), size: Vector2(6, 1)),
      ],
    ),

    // ========== MEDIUM (6-10) ==========
    LevelModel(
      id: 6,
      name: "Piège Mortel",
      difficulty: 2,
      timeLimit: 45,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(3, 2), size: Vector2(1, 6)),
        WallData(position: Vector2(6, 4), size: Vector2(1, 6)),
        WallData(position: Vector2(2, 11), size: Vector2(5, 1)),
      ],
      traps: [
        TrapData(position: Vector2(2, 5)),
        TrapData(position: Vector2(5, 8)),
        TrapData(position: Vector2(7, 12)),
        TrapData(position: Vector2(4, 3)),
      ],
    ),

    LevelModel(
      id: 7,
      name: "Téléportation",
      difficulty: 2,
      timeLimit: 45,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(0, 5), size: Vector2(9, 1)),
        WallData(position: Vector2(1, 10), size: Vector2(9, 1)),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(8, 3), positionB: Vector2(1, 7)),
        TeleporterData(positionA: Vector2(8, 8), positionB: Vector2(1, 12)),
      ],
    ),

    LevelModel(
      id: 8,
      name: "Murs Vivants",
      difficulty: 2,
      timeLimit: 40,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 1),
      goalPosition: Vector2(8, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(3, 4), size: Vector2(1, 3)),
        WallData(position: Vector2(6, 9), size: Vector2(1, 3)),
      ],
      movingWalls: [
        MovingWallData(
          start: Vector2(1, 6),
          end: Vector2(7, 6),
          size: Vector2(2, 1),
          speed: 2,
        ),
        MovingWallData(
          start: Vector2(7, 10),
          end: Vector2(1, 10),
          size: Vector2(2, 1),
          speed: 2.5,
        ),
      ],
    ),

    LevelModel(
      id: 9,
      name: "L'Entonnoir",
      difficulty: 2,
      timeLimit: 40,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(5, 1),
      goalPosition: Vector2(5, 14),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(1, 4), size: Vector2(3, 1)),
        WallData(position: Vector2(6, 4), size: Vector2(3, 1)),
        WallData(position: Vector2(2, 7), size: Vector2(2, 1)),
        WallData(position: Vector2(6, 7), size: Vector2(2, 1)),
        WallData(position: Vector2(3, 10), size: Vector2(1, 1)),
        WallData(position: Vector2(6, 10), size: Vector2(1, 1)),
        WallData(position: Vector2(4, 12), size: Vector2(2, 1)),
      ],
      traps: [
        TrapData(position: Vector2(5, 6)),
        TrapData(position: Vector2(4, 9)),
        TrapData(position: Vector2(6, 9)),
      ],
    ),

    LevelModel(
      id: 10,
      name: "Le Boss",
      difficulty: 3,
      timeLimit: 35,
      gridSize: Vector2(10, 16),
      startPosition: Vector2(1, 14),
      goalPosition: Vector2(5, 1),
      walls: [
        ..._generateBorders(10, 16),
        WallData(position: Vector2(3, 2), size: Vector2(1, 4)),
        WallData(position: Vector2(6, 1), size: Vector2(1, 5)),
        WallData(position: Vector2(1, 6), size: Vector2(5, 1)),
        WallData(position: Vector2(4, 8), size: Vector2(5, 1)),
        WallData(position: Vector2(2, 10), size: Vector2(4, 1)),
        WallData(position: Vector2(7, 10), size: Vector2(1, 4)),
        WallData(position: Vector2(3, 12), size: Vector2(3, 1)),
      ],
      traps: [
        TrapData(position: Vector2(2, 4)),
        TrapData(position: Vector2(5, 7)),
        TrapData(position: Vector2(3, 11)),
        TrapData(position: Vector2(8, 13)),
      ],
      movingWalls: [
        MovingWallData(
          start: Vector2(6, 6),
          end: Vector2(8, 6),
          size: Vector2(1, 1),
          speed: 3,
        ),
      ],
      teleporters: [
        TeleporterData(positionA: Vector2(1, 8), positionB: Vector2(8, 3)),
      ],
    ),
  ];

  // Génération automatique des bordures
  static List<WallData> _generateBorders(int width, int height) {
    return [
      WallData(position: Vector2(0, 0), size: Vector2(width.toDouble(), 1)),           // haut
      WallData(position: Vector2(0, height - 1), size: Vector2(width.toDouble(), 1)),   // bas
      WallData(position: Vector2(0, 0), size: Vector2(1, height.toDouble())),           // gauche
      WallData(position: Vector2(width - 1, 0), size: Vector2(1, height.toDouble())),   // droite
    ];
  }
}