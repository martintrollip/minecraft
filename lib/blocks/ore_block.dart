import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/items.dart';

class OreBlock extends BlockComponent {
  OreBlock({
    required super.index,
    required super.chunkIndex,
    required super.block,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    switch (block) {
      case Blocks.coalOre:
        itemDropped = Items.coal;
        break;
      case Blocks.ironOre:
        itemDropped = Items.ironIngot;
        break;
      case Blocks.goldOre:
        itemDropped = Items.goldIngot;
        break;
      case Blocks.diamondOre:
        itemDropped = Items.diamond;
        break;
      default:
        break;
    }
  }
}
