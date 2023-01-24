import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/player_data.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 spriteSize = Vector2.all(60);
  final double stepTime = 0.2;
  var isFacingRight = true;
  var yVelocity = 0.0;
  var isCollidingGround = false;
  var isCollidingLeft = false;
  var isCollidingRight = false;

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
      image: await Flame.images
          .load('sprite_sheets/player/player_idle_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    walkingSheet = SpriteSheet(
      image: await Flame.images
          .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
      srcSize: spriteSize,
    );

    animation = idleAnimation;

    size = GameMethods.instance.blockSize * 1.5;
    position = Vector2(0, 100);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    intersectionPoints.forEach((Vector2 point) {
      if (point.y > (position.y - (size.y * 0.4)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.4)) {
        isCollidingGround = true;
      }

      if (point.y < (position.y - (size.y * 0.4))) {
        if (point.x > position.x) {
          isCollidingRight = true;
        } else {
          isCollidingLeft = true;
        }
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    _movement(dt);
    _gravity(dt);
    _resetCollision();
  }

  void _movement(double dt) {
    final adjustedSpeed = GameMethods.instance.getSpeed(dt);

    switch (GlobalGameReference
        .instance.game.worldData.playerData.componentMotionState) {
      case ComponentMotionState.walkingLeft:
        _moveLeft(adjustedSpeed);
        break;
      case ComponentMotionState.walkingRight:
        _moveRight(adjustedSpeed);
        break;
      case ComponentMotionState.idle:
        _stand();
        break;
    }
  }

  void _moveLeft(double speed) {
    if (!isCollidingLeft) {
      animation = walkingAnimation;
      position.x -= speed;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    }
  }

  void _moveRight(double speed) {
    if (!isCollidingRight) {
      animation = walkingAnimation;
      position.x += speed;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    }
  }

  void _stand() {
    if (isCollidingLeft || isCollidingRight) {
      animation = idleAnimation;
    }
  }

  void _gravity(double dt) {
    if (!isCollidingGround) {
      final adjustedGravity = GameMethods.instance.getGravity(dt);

      if (yVelocity < adjustedGravity * 5) {
        yVelocity += adjustedGravity;
      }
      position.y += yVelocity;
    } else {
      yVelocity = 0;
    }
  }

  void _resetCollision() {
    isCollidingGround = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize * 1.5;
  }
}
