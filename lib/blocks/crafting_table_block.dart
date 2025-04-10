import 'package:flame/events.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';

class CraftingTableBlock extends BlockComponent with TapCallbacks {
  CraftingTableBlock({
    required super.block,
    required super.index,
    required super.chunkIndex,
  });

  @override
  void onTapUp(TapUpEvent event) {
    GlobalGameReference.instance.game.worldData.craftingManger.toggle();
    super.onTapUp(event);
  }
}
