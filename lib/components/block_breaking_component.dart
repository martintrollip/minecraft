import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/utils/game_methods.dart';

class BlockBreakingComponent extends SpriteAnimationComponent {
  BlockBreakingComponent(
      {required this.baseSpeed, required this.onAnimationComplete});

  final Vector2 spriteSize = Vector2.all(60);
  final double baseSpeed;
  final void Function() onAnimationComplete;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    SpriteSheet animationSheet = SpriteSheet(
        image: Flame.images
            .fromCache('sprite_sheets/blocks/block_breaking_sprite_sheet.png'),
        srcSize: spriteSize);

    animation = animationSheet.createAnimation(
        row: 0, stepTime: baseSpeed / 10, loop: false);

    animation!.onComplete = onAnimationComplete;

    size = GameMethods.instance.blockSize;
  }
}
