import 'package:flame/input.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';

class CraftingTableBlock extends BlockComponent {
  CraftingTableBlock({
    required super.block,
    required super.index,
    required super.chunkIndex,
  });

  @override
  bool onTapUp(TapUpInfo info) {
    print('Martin on up!');
    GlobalGameReference.instance.game.worldData.craftingManger.toggle();
    return super.onTapUp(info);
  }
}
