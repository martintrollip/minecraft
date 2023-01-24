import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/player_data.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 spriteSize = Vector2.all(60);
  final double stepTime = 0.2;
  final speed = 5.0;
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
    position = Vector2(550, 100);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    intersectionPoints.forEach((Vector2 point) {
      if (point.y > (position.y - (size.y * 0.3)) &&
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              (size.x * 0.4)) {
        isCollidingGround = true;
      }

      if (point.y < (position.y - (size.y * 0.3))) {
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
    _movement();
    _gravity();

    isCollidingGround = false;
    isCollidingLeft = false;
    isCollidingRight = false;
  }

  void _movement() {
    var movement = GlobalGameReference
        .instance.game.worldData.playerData.componentMotionState;

    if (movement == ComponentMotionState.walkingLeft && !isCollidingLeft) {
      animation = walkingAnimation;
      position.x -= speed;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    }

    if (movement == ComponentMotionState.walkingRight && !isCollidingRight) {
      animation = walkingAnimation;
      position.x += speed;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    }

    if (movement == ComponentMotionState.idle ||
        (isCollidingLeft || isCollidingRight)) {
      animation = idleAnimation;
    }
  }

  void _gravity() {
    if (!isCollidingGround) {
      if (yVelocity < gravity * 5) {
        yVelocity += gravity;
      }
      position.y += yVelocity;
    } else {
      yVelocity = 0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize * 1.5;
  }
}
