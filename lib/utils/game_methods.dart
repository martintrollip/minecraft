import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/items.dart';
import 'package:minecraft/utils/constant.dart';

enum Direction { left, right, top, bottom }

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
    return Vector2.all(20);
    return Vector2.all(screenSize().width / chunkWidth);
  }

  double get inventorySlotSize {
    return screenSize().height * 0.09;
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

  SpriteSheet blockSpriteSheet() {
    return SpriteSheet(
      image: Flame.images.fromCache(
        'sprite_sheets/blocks/block_sprite_sheet.png',
      ),
      srcSize: Vector2.all(60),
    );
  }

  SpriteSheet itemSpriteSheet() {
    return SpriteSheet(
      image: Flame.images.fromCache(
        'sprite_sheets/item/item_sprite_sheet.png',
      ),
      srcSize: Vector2.all(60),
    );
  }

  Sprite getSprite(dynamic from) {
    if (from is Blocks) {
      return _getBlockSprite(from);
    } else if (from is Items) {
      return _getItemSprite(from);
    } else {
      throw Exception('Invalid type');
    }
  }

  Sprite _getBlockSprite(Blocks block) {
    final sheet = blockSpriteSheet();
    return sheet.getSprite(0, block.index);
  }

  Sprite _getItemSprite(Items item) {
    final sheet = itemSpriteSheet();
    return sheet.getSprite(0, item.index);
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
    return gravity * GameMethods.instance.blockSize.y * dt;
  }

  // Adjust for framerate by using dt
  double getSpeed(double dt) {
    return playerSpeed * GameMethods.instance.blockSize.x * dt;
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

  double get playerY {
    return GlobalGameReference.instance.game.playerComponent.position.y /
        blockSize.y;
  }

  Vector2 get playerIndex {
    final playerPosition =
        GlobalGameReference.instance.game.playerComponent.position;
    return Vector2(
        playerPosition.x / blockSize.x, playerPosition.y / blockSize.y);
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

  Vector2 getBlockIndexFrom(Vector2 gamePixels) {
    return Vector2(
      (gamePixels.x / blockSize.x).floorToDouble(),
      (gamePixels.y / blockSize.y).floorToDouble(),
    );
  }

  int getChunkIndexFrom(Vector2 blockIndex) {
    return blockIndex.x >= 0
        ? blockIndex.x ~/ chunkWidth
        : (blockIndex.x ~/ chunkWidth) - 1;
  }

  void replaceBlock(Blocks? block, Vector2 blockIndex) {
    if (blockIndex.x >= 0) {
      GlobalGameReference.instance.game.worldData
          .rightWorldChunks[blockIndex.y.toInt()][blockIndex.x.toInt()] = block;
    } else {
      GlobalGameReference
              .instance.game.worldData.leftWorldChunks[blockIndex.y.toInt()]
          [blockIndex.x.toInt().abs() - 1] = block;
    }
  }

  bool canPlaceBlock(Vector2 positionIndex) {
    if (playerIndex.distanceTo(positionIndex).ceil() <= maxPlacementRadius &&
        getBlockAt(positionIndex) == null &&
        isAdjacent(positionIndex)) {
      return true;
    }
    return false;
  }

  Blocks? getBlockAt(Vector2 index) {
    if (index.x >= 0) {
      return GlobalGameReference.instance.game.worldData
          .rightWorldChunks[index.y.toInt()][index.x.toInt()];
    } else {
      //TODO on the left we have bugs where were not clicking on the correct blocks
      //TODO sometime a chunk is duplicated
      //TODO block placements are not the same if we unload and reload the same chunk
      return GlobalGameReference.instance.game.worldData
          .leftWorldChunks[index.y.toInt()][index.x.toInt().abs() - 1];
    }
  }

  bool isAdjacent(Vector2 index) {
    // Top
    if (getBlockAt(Vector2(index.x, index.y - 1)) != null) {
      return true;
    }

    // Bottom
    if (getBlockAt(Vector2(index.x, index.y + 1)) != null) {
      return true;
    }

    // Left
    if (getBlockAt(Vector2(index.x - 1, index.y)) != null) {
      return true;
    }

    // Right
    if (getBlockAt(Vector2(index.x + 1, index.y)) != null) {
      return true;
    }

    return false;
  }

  static int counter = 0;
  Vector2 getSpawnPositionForMob() {
    int currentSeed = seed(playerChunk) + counter++;
    int index = Random(currentSeed).nextBool()
        ? GlobalGameReference.instance.game.worldData.chunksToRender.first
        : GlobalGameReference.instance.game.worldData.chunksToRender.last;

    final chunk = getChunk(index);

    final x = Random(currentSeed).nextInt(chunkWidth);
    late final int yPos;
    for (var y = 0; y < chunkHeight; y++) {
      if (BlockData.getFor(chunk[y][x]).isCollidable) {
        yPos = y;
        break;
      }
    }

    return Vector2(x.toDouble() + (index * chunkWidth), yPos.toDouble());
  }
}
