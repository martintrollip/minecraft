import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/player_data.dart';

class PlayerComponent extends Entity {
  final Vector2 spriteSize = Vector2.all(60);
  final double stepTime = 0.2;

  var localPlayerSpeed = 0.0;
  var refreshSpeed = true;

  late SpriteSheet walkingSheet;
  late SpriteSheet idleSheet;

  late SpriteAnimation walkingAnimation =
      walkingSheet.createAnimation(row: 0, stepTime: stepTime / 2);

  late SpriteAnimation idleAnimation =
      idleSheet.createAnimation(row: 0, stepTime: stepTime);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(RectangleHitbox());

    priority = 2;
    anchor = Anchor.bottomCenter;

    idleSheet = SpriteSheet(
      image: Flame.images
          .fromCache('sprite_sheets/player/player_idle_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    walkingSheet = SpriteSheet(
      image: Flame.images
          .fromCache('sprite_sheets/player/player_walking_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    animation = idleAnimation;

    size = GameMethods.instance.blockSize * 1.5;
    position = Vector2(0, 100);

    add(TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        refreshSpeed = true;
      },
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    movement(
      GlobalGameReference
          .instance.game.worldData.playerData.componentMotionState,
      dt,
      localPlayerSpeed,
    );
    gravity(dt);
    jumpLogic();
    resetCollision();

    if (refreshSpeed) {
      localPlayerSpeed = GameMethods.instance.getSpeed(dt);
      refreshSpeed = false;
    }
  }

  void movement(ComponentMotionState motionState, double dt, double speed) {
    switch (motionState) {
      case ComponentMotionState.walkingLeft:
        moveLeft(speed);
        animation = walkingAnimation;
        break;
      case ComponentMotionState.walkingRight:
        moveRight(speed);
        animation = walkingAnimation;
        break;
      case ComponentMotionState.idle:
        stand();
        animation = idleAnimation;
        break;
      case ComponentMotionState.jumping:
        jump();
        animation = idleAnimation;
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BlockComponent && other.blockData.isCollidable) {
      super.onCollision(intersectionPoints, other);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize * 1.5;
  }
}
