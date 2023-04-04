import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/mob.dart';
import 'package:minecraft/utils/game_methods.dart';

class Spider extends Mob {
  Spider()
      : super(
          spriteSheetPath: 'sprite_sheets/mobs/sprite_sheet_spider.png',
          spriteSize: Vector2(131, 60),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = spriteSize * (GameMethods.instance.blockSize.y / spriteSize.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gravity(dt);
    jumpLogic();
    killEntityLogic();
    spiderLogic(dt);
    resetCollision();
  }

  @override
  void jump() {
    jumpForce = GameMethods.instance.jumpForce * 1;
  }

  @override
  void gravity(double dt, [int modifier = 0]) {
    if (!isCollidingGround) {
      final adjustedGravity = GameMethods.instance.getGravity(dt) - modifier;
      if (yVelocity < adjustedGravity * 2) {
        yVelocity += adjustedGravity;
      }
      position.y += yVelocity;
      blocksFallen += yVelocity / GameMethods.instance.blockSize.y;
    }
  }

  void spiderLogic(double dt) {
    final playerComponent = GlobalGameReference.instance.game.playerComponent;
    final speed = GameMethods.instance.getSpeed(dt) / 3;
    final distance = playerComponent.position.distanceTo(position);

    if (distance < 400) {
      isAggravated = true;
    } else if (distance > 1000) {
      isAggravated = false;
    }

    if (collidingWith(playerComponent) || !isAggravated) {
      movement(ComponentMotionState.idle, dt, speed);
      return;
    }

    late bool moved;
    if (playerComponent.position.x > position.x) {
      moved = movement(ComponentMotionState.walkingRight, dt, speed);
    } else {
      moved = movement(ComponentMotionState.walkingLeft, dt, speed);
    }

    if (!moved) {
      movement(ComponentMotionState.jumping, dt, 0);
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = spriteSize * (GameMethods.instance.blockSize.y / spriteSize.y);
  }
}
