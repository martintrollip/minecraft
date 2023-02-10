import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/chunk_generation_methods.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

class MainGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  MainGame({required this.worldData, bool debug = false}) {
    globalGameReference.game = this;
    debugMode = debug;
  }

  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());
  PlayerComponent playerComponent =
      PlayerComponent(); //Get.put(PlayerComponent());

  final WorldData worldData;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.followComponent(playerComponent);

    add(playerComponent);

    if (debugMode) {
      add(FpsTextComponent());
    }
  }

  void renderChunk(int chunkIndex) {
    final chunk = GameMethods.instance.getChunk(chunkIndex);
    final offset = chunkIndex * chunkWidth;
    chunk.asMap().forEach((int yIndex, List<Blocks?> row) {
      row.asMap().forEach((int xIndex, Blocks? block) {
        if (block != null) {
          add(
            BlockComponent(
              block: block,
              index: Vector2(xIndex.toDouble() + offset, yIndex.toDouble()),
              chunkIndex: chunkIndex,
            ),
          );
        }
      });
    });
  }

  @override
  void update(double dt) {
    super.update(dt);

    _renderItems();

    worldData.chunksToRender.asMap().forEach((_, index) {
      if (!worldData.visibleChunks.contains(index)) {
        // chunk not rendered yet
        if (worldData.rightWorldChunks[0].length ~/ chunkWidth <= index + 1 ||
            worldData.leftWorldChunks[0].length ~/ chunkWidth >= index + 1) {
          // chunk not created yet
          GameMethods.instance.addChunkToWorld(
            ChunkGenerationMethods.instance.generateChunks(index),
            index >= 0,
          );
        } else {
          // chunk already created
        }

        renderChunk(index);
        worldData.visibleChunks.add(index);
      }
    });
  }

  void _renderItems() {
    worldData.items.asMap().forEach((index, item) {
      if (!item.isMounted) {
        if (worldData.chunksToRender.contains(
            GameMethods.instance.getChunkIndexFrom(item.spawnBlockIndex))) {
          add(item);
        }
      } else {
        if (!worldData.chunksToRender.contains(
            GameMethods.instance.getChunkIndexFrom(item.spawnBlockIndex))) {
          remove(item);
        }
      }
    });
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      GameMethods.instance.leftAction();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      GameMethods.instance.rightAction();
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      GameMethods.instance.jumpAction();
    }

    if (keysPressed.isEmpty) {
      GameMethods.instance.idleAction();
    }

    return KeyEventResult.ignored;
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    _placeBlock(info.eventPosition.game);
  }

  void _placeBlock(Vector2 pixels) {
    final blockIndex = GameMethods.instance.getBlockIndexFrom(pixels);
    final chunkIndex = GameMethods.instance.getChunkIndexFrom(blockIndex);

    if (blockIndex.y > 0 &&
        blockIndex.y < chunkHeight &&
        GameMethods.instance.canPlaceBlock(blockIndex)) {
      final block = BlockComponent(
        block: Blocks.sand,
        index: blockIndex,
        chunkIndex: chunkIndex,
      );

      GameMethods.instance.replaceBlock(block.block, blockIndex);
      add(block);
    }
  }
}
