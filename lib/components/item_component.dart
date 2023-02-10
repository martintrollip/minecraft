import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/game_methods.dart';

class ItemComponent extends Entity {
  final Vector2 spawnBlockIndex;
  final Blocks block;

  ItemComponent(this.spawnBlockIndex, this.block);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    anchor = Anchor.bottomLeft;
    size = GameMethods.instance.blockSize * 0.4;

    //Randomize x position
    position = Vector2(
      spawnBlockIndex.x * GameMethods.instance.blockSize.x +
          (GameMethods.instance.blockSize.x * Random().nextDouble()),
      spawnBlockIndex.y * GameMethods.instance.blockSize.y,
    );
    animation = SpriteAnimation.spriteList(
      [GameMethods.instance.blockSprite(block)],
      stepTime: 1,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    gravity(dt, 2);
    // Add slight bouncy animation
    // position.x += sin(position.x * 10) * 2.5;
    resetCollision();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = GameMethods.instance.blockSize * 0.4;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BlockComponent && other.blockData.isCollidable) {
      super.onCollision(intersectionPoints, other);
    } else if (other is PlayerComponent) {
      GlobalGameReference.instance.game.worldData.items.remove(this);
      removeFromParent();
      print("add $block to inventory ");
    }
  }
}
