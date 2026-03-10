import 'package:flame/components.dart';

enum TileType { empty, wall, trap, teleporter, start, goal }

class LevelModel {
  final int id;
  final String name;
  final int difficulty; // 1=easy, 2=medium, 3=hard
  final int timeLimit;  // secondes
  final Vector2 gridSize;
  final Vector2 startPosition;
  final Vector2 goalPosition;
  final List<WallData> walls;
  final List<TrapData> traps;
  final List<TeleporterData> teleporters;
  final List<MovingWallData> movingWalls;

  LevelModel({
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
  });
}

class WallData {
  final Vector2 position;
  final Vector2 size;
  WallData({required this.position, required this.size});
}

class TrapData {
  final Vector2 position;
  TrapData({required this.position});
}

class TeleporterData {
  final Vector2 positionA;
  final Vector2 positionB;
  TeleporterData({required this.positionA, required this.positionB});
}

class MovingWallData {
  final Vector2 start;
  final Vector2 end;
  final Vector2 size;
  final double speed;
  MovingWallData({
    required this.start,
    required this.end,
    required this.size,
    required this.speed,
  });
}