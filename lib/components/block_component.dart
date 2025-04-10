import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:minecraft/components/block_breaking_component.dart';
import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/tools.dart';
import 'package:minecraft/utils/game_methods.dart';

class BlockComponent extends SpriteComponent with TapCallbacks {
  BlockComponent({
    required this.block,
    required this.index,
    required this.chunkIndex,
    this.itemDropped,
  });

  final Blocks block;
  dynamic itemDropped;
  late final BlockData blockData;
  final Vector2 index;
  final int chunkIndex;

  late BlockBreakingComponent breaking;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    blockData = BlockData.getFor(block);
    add(RectangleHitbox(size: size - (size * 0.1)));
    sprite = GameMethods.instance.getSprite(block);
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

  void addBreaking() {
    if (blockData.breakable) {
      breaking = BlockBreakingComponent(
        baseSpeed: getMiningSpeedFor(block),
        onAnimationComplete: onBroken,
      );
    }

    if (!breaking.isMounted) {
      add(breaking);
    }
  }

  void onBroken() {
    GameMethods.instance.replaceBlock(null, index);
    GlobalGameReference.instance.game.worldData.items
        .add(ItemComponent(index, itemDropped ?? block));
    removeFromParent();
  }

  void removeBreaking() {
    if (breaking.isMounted) {
      // TODO //breaking.animation!.reset();
      remove(breaking);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    addBreaking();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    removeBreaking();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    removeBreaking();
  }
}
