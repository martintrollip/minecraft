import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/player_data.dart';

class PlayerComponent extends SpriteAnimationComponent {
  final Vector2 spriteSize = Vector2.all(60);
  final double stepTime = 0.2;
  final speed = 5.0;
  var isFacingRight = true;
  var yVelocity = 0.0;

  late SpriteSheet walkingSheet;
  late SpriteSheet idleSheet;

  late SpriteAnimation walkingAnimation =
      walkingSheet.createAnimation(row: 0, stepTime: stepTime / 2);

  late SpriteAnimation idleAnimation =
      idleSheet.createAnimation(row: 0, stepTime: stepTime);

  @override
  Future<void> onLoad() async {
    super.onLoad();

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
    position = Vector2(0, 400);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _movement();
    _gravity();
  }

  void _movement() {
    switch (GlobalGameReference
        .instance.game.worldData.playerData.componentMotionState) {
      case ComponentMotionState.walkingLeft:
        animation = walkingAnimation;
        position.x -= speed;
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        break;
      case ComponentMotionState.walkingRight:
        animation = walkingAnimation;
        position.x += speed;
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        break;
      case ComponentMotionState.idle:
        animation = idleAnimation;
        break;
    }
  }

  void _gravity() {
    if (yVelocity < gravity * 5) {
      yVelocity += gravity;
    }
    position.y += yVelocity;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize * 1.5;
  }
}
