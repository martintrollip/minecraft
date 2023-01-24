import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/game_methods.dart';

class BlockComponent extends SpriteComponent {
  BlockComponent({
    required this.block,
    required this.index,
    required this.chunkIndex,
  });

  final Blocks block;
  final Vector2 index;
  final int chunkIndex;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox(size: size - (size * 0.1)));
    sprite = await GameMethods.instance.blockSprite(block);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = GameMethods.instance.blockSize;
    position = Vector2(
      index.x * GameMethods.instance.blockSize.x,
      index.y * GameMethods.instance.blockSize.y,
    );
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (!GlobalGameReference.instance.game.worldData.chunksToRender
        .contains(chunkIndex)) {
      removeFromParent();

      GlobalGameReference.instance.game.worldData.visibleChunks
          .remove(chunkIndex);
    }
  }
}
