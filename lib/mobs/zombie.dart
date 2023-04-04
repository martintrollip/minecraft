import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/mob.dart';
import 'package:minecraft/utils/game_methods.dart';

class Zombie extends Mob {
  Zombie({required super.spawnIndexPosition})
      : super(
          spriteSheetPath: 'sprite_sheets/mobs/sprite_sheet_zombie.png',
          spriteSize: Vector2(67, 99),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = spriteSize * (GameMethods.instance.blockSize.x * 2 / spriteSize.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    gravity(dt);
    jumpLogic();
    killEntityLogic();
    zombieLogic(dt);
    resetCollision();
  }

  void zombieLogic(double dt) {
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
    size = spriteSize * (GameMethods.instance.blockSize.x * 2 / spriteSize.y);
  }
}
