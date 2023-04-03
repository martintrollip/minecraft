import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/game_methods.dart';

class Zombie extends Entity {
  final Vector2 spriteSize = Vector2(67, 99);
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
      image: Flame.images.fromCache(
        'sprite_sheets/mobs/sprite_sheet_zombie.png',
      ),
      srcSize: spriteSize,
    );

    animation = walkingAnimation;

    size = GameMethods.instance.blockSize * 1.5;
    position = Vector2(500, 100);

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

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size =
        spriteSize * (GameMethods.instance.blockSize.x * 2 / spriteSize.y);
  }
}
