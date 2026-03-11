import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard, expert }

class LevelModel {
  final int id;
  final String name;
  final Difficulty difficulty;
  final int timeLimit;
  final Vector2 gridSize;
  final Vector2 startPosition;
  final Vector2 goalPosition;
  final List<WallData> walls;
  final List<TrapData> traps;
  final List<TeleporterData> teleporters;
  final List<MovingWallData> movingWalls;
  final List<CollectibleData> collectibles;
  final String? hintText;

  const LevelModel({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.timeLimit,
    required this.gridSize,
    required this.startPosition,
    required this.goalPosition,
    required this.walls,
    this.traps = const [],
    this.teleporters = const [],
    this.movingWalls = const [],
    this.collectibles = const [],
    this.hintText,
  });

  /// Vérifie que le niveau est valide
  bool get isValid {
    // Start et Goal ne doivent pas être sur un mur
    for (var w in walls) {
      if (_isInsideWall(startPosition, w) || _isInsideWall(goalPosition, w)) {
        return false;
      }
    }
    // Start et Goal doivent être dans la grille
    if (startPosition.x < 1 || startPosition.x >= gridSize.x - 1) return false;
    if (startPosition.y < 1 || startPosition.y >= gridSize.y - 1) return false;
    if (goalPosition.x < 1 || goalPosition.x >= gridSize.x - 1) return false;
    if (goalPosition.y < 1 || goalPosition.y >= gridSize.y - 1) return false;
    return true;
  }

  bool _isInsideWall(Vector2 point, WallData wall) {
    return point.x >= wall.position.x &&
        point.x < wall.position.x + wall.size.x &&
        point.y >= wall.position.y &&
        point.y < wall.position.y + wall.size.y;
  }

  Color get difficultyColor => switch (difficulty) {
    Difficulty.easy => const Color(0xFF00FF87),
    Difficulty.medium => const Color(0xFFFFE66D),
    Difficulty.hard => const Color(0xFFFF006E),
    Difficulty.expert => const Color(0xFFBD00FF),
  };

  String get difficultyLabel => switch (difficulty) {
    Difficulty.easy => "FACILE",
    Difficulty.medium => "MOYEN",
    Difficulty.hard => "DIFFICILE",
    Difficulty.expert => "EXPERT",
  };
}

class WallData {
  final Vector2 position;
  final Vector2 size;
  const WallData({required this.position, required this.size});
}

class TrapData {
  final Vector2 position;
  final TrapType type;
  const TrapData({required this.position, this.type = TrapType.static});
}

enum TrapType { static, blinking, moving }

class TeleporterData {
  final Vector2 positionA;
  final Vector2 positionB;
  final int groupId;
  const TeleporterData({
    required this.positionA,
    required this.positionB,
    this.groupId = 0,
  });
}

class MovingWallData {
  final Vector2 start;
  final Vector2 end;
  final Vector2 size;
  final double speed;
  final double delay;
  const MovingWallData({
    required this.start,
    required this.end,
    required this.size,
    required this.speed,
    this.delay = 0,
  });
}

class CollectibleData {
  final Vector2 position;
  final int points;
  const CollectibleData({required this.position, this.points = 100});
}