import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constant.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  PlayerData _playerRef() {
    return GlobalGameReference.instance.game.worldData.playerData;
  }

  void leftAction() {
    _playerRef().componentMotionState = ComponentMotionState.walkingLeft;
  }

  void rightAction() {
    _playerRef().componentMotionState = ComponentMotionState.walkingRight;
  }

  void jumpAction() {
    _playerRef().componentMotionState = ComponentMotionState.jumping;
  }

  void idleAction() {
    _playerRef().componentMotionState = ComponentMotionState.idle;
  }

  Vector2 get blockSize {
    // return Vector2.all(20);
    return Vector2.all(screenSize().width / chunkWidth);
  }

  int get freeArea {
    return (chunkHeight * 0.4).toInt();
  }

  int get maxSecondarySoilDepth {
    return freeArea + 6;
  }

  Size screenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  Future<SpriteSheet> blockSpriteSheet() async {
    return SpriteSheet(
      image: await Flame.images.load(
        'sprite_sheets/blocks/block_sprite_sheet.png',
      ),
      srcSize: Vector2.all(60),
    );
  }

  Future<Sprite> blockSprite(Blocks block) async {
    final sheet = await blockSpriteSheet();
    return sheet.getSprite(0, block.index);
  }

  void addChunkToWorld(List<List<Blocks?>> chunk, bool isRight) {
    chunk.asMap().forEach((yIndex, List<Blocks?> value) {
      if (isRight) {
        GlobalGameReference.instance.game.worldData.rightWorldChunks[yIndex]
            .addAll(value);
      } else {
        GlobalGameReference.instance.game.worldData.leftWorldChunks[yIndex]
            .addAll(value);
      }
    });
  }

  List<List<Blocks?>> getChunk(int index) {
    final chunk = <List<Blocks?>>[];

    if (index >= 0) {
      GlobalGameReference.instance.game.worldData.rightWorldChunks
          .asMap()
          .forEach((yIndex, List<Blocks?> row) {
        chunk.add(row.sublist(getStartIndex(index), getEndIndex(index)));
      });
    } else {
      GlobalGameReference.instance.game.worldData.leftWorldChunks
          .asMap()
          .forEach((yIndex, List<Blocks?> row) {
        chunk.add(row.sublist(getStartIndex(index), getEndIndex(index)));
      });
    }

    return chunk;
  }

  // Adjust for framerate by using dt
  double getGravity(double dt) {
    return 3 * GameMethods.instance.blockSize.y * dt;
  }

  // Adjust for framerate by using dt
  double getSpeed(double dt) {
    return 4 * GameMethods.instance.blockSize.x * dt;
  }

  double get jumpForce {
    return 1.5 * GameMethods.instance.blockSize.y;
  }

  int getStartIndex(int chunkIndex) {
    return chunkIndex >= 0
        ? chunkIndex * chunkWidth
        : (chunkIndex.abs() - 1) * chunkWidth;
  }

  int getEndIndex(int chunkIndex) {
    return chunkIndex >= 0
        ? (chunkIndex + 1) * chunkWidth
        : (chunkIndex.abs()) * chunkWidth;
  }

  int seed(int index) {
    final initial = GlobalGameReference.instance.game.worldData.seed;

    return index == 0
        ? initial
        : index.sign == -1
            ? initial * (index.abs() * 10)
            : initial * (index.abs() + 2);
  }

  double get playerX {
    return GlobalGameReference.instance.game.playerComponent.position.x /
        blockSize.x;
  }

  int get playerChunk {
    return playerX >= 0 ? playerX ~/ chunkWidth : playerX ~/ chunkWidth - 1;
  }

  List<List<int>> processNoise(List<List<double>> raw) {
    final processed = List.generate(
      raw.length,
      (index) => List.generate(raw[0].length, ((index) => 255)),
    );

    final w = raw.length;
    final h = raw[0].length;

    for (var x = 0; x < w; x++) {
      for (var y = 0; y < h; y++) {
        var value = (0x80 + 0x80 * raw[x][y]).floor();
        processed[x][y] = value;
      }
    }

    return processed;
  }
}
