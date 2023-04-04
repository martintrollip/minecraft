import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/game_methods.dart';

class Mob extends Entity {
  Mob({
    required this.spriteSheetPath,
    required this.spriteSize,
    required this.spawnIndexPosition,
  });

  final String spriteSheetPath;
  final Vector2 spriteSize;
  final Vector2 spawnIndexPosition;

  final double stepTime = 0.2;
  bool isAggravated = false;
  bool canJump = true;
  bool canDamage = true;

  late SpriteSheet spriteSheet;

  late SpriteAnimation idleAnimation =
      spriteSheet.createAnimation(row: 0, from: 0, to: 1, stepTime: stepTime);

  late SpriteAnimation idleHurtAnimation =
      spriteSheet.createAnimation(row: 1, from: 0, to: 1, stepTime: stepTime);

  late SpriteAnimation walkingAnimation =
      spriteSheet.createAnimation(row: 2, stepTime: stepTime / 2);

  late SpriteAnimation walkingHurtAnimation =
      spriteSheet.createAnimation(row: 3, stepTime: stepTime / 2);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox());

    priority = 2;
    anchor = Anchor.bottomCenter;

    spriteSheet = SpriteSheet(
      image: Flame.images.fromCache(spriteSheetPath),
      srcSize: spriteSize,
    );

    animation = walkingAnimation;

    size = GameMethods.instance.blockSize * 1.5;
    position = Vector2(
      spawnIndexPosition.x * GameMethods.instance.blockSize.x,
      spawnIndexPosition.y * GameMethods.instance.blockSize.y,
    );

    add(
      TimerComponent(
        period: 3,
        repeat: true,
        onTick: () {
          canJump = true;
        },
      ),
    );

    add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          canDamage = true;
        },
      ),
    );
  }

  bool movement(ComponentMotionState motionState, double dt, double speed) {
    late bool moved;
    switch (motionState) {
      case ComponentMotionState.walkingLeft:
        moved = moveLeft(speed);
        break;
      case ComponentMotionState.walkingRight:
        moved = moveRight(speed);
        break;
      case ComponentMotionState.idle:
        moved = false;
        stand();
        break;
      case ComponentMotionState.jumping:
        if (canJump) {
          jump();
          canJump = false;
        }
        moved = false;
        break;
    }

    if (moved) {
      animation = isHurt ? walkingHurtAnimation : walkingAnimation;
    } else {
      animation = isHurt ? idleHurtAnimation : idleAnimation;
    }

    return moved;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BlockComponent && other.blockData.isCollidable) {
      super.onCollision(intersectionPoints, other);
    }

    if (other is PlayerComponent) {
      if (canDamage) {
        other.takeDamage(
            other.position.x > position.x
                ? ComponentMotionState.walkingRight
                : ComponentMotionState.walkingLeft,
            1);
        canDamage = false;
      }
    }
  }
}
