import 'package:minecraft/resources/blocks.dart';

enum Tools {
  none,
  sword,
  shovel,
  pickaxe,
  axe,
}

enum Items {
  woodenSword,
  woodenShovel,
  woodenPickaxe,
  woodenAxe,
  stoneSword,
  stoneShovel,
  stonePickaxe,
  stoneAxe,
  ironSword,
  ironShovel,
  ironPickaxe,
  ironAxe,
  diamondSword,
  diamondShovel,
  diamondPickaxe,
  diamondAxe,
  goldenSword,
  goldenShovel,
  goldenPickaxe,
  goldenAxe,
  coal,
  ironIngot,
  diamond,
  apple,
  stick,
  goldIngot,
}

class ItemData {
  const ItemData({this.tool = Tools.none, this.isFood = false});

  final Tools tool;
  final bool isFood;

  static bool canStack(dynamic item) {
    if (item is Blocks) {
      return true;
    }

    if (item is Items) {
      final tool = ItemData.from(item: item).tool;
      switch (tool) {
        case Tools.none:
          return true;
        default:
          return false;
      }
    }

    return false;
  }

  factory ItemData.from({required Items item}) {
    switch (item) {
      case Items.woodenSword:
      case Items.stoneSword:
      case Items.ironSword:
      case Items.diamondSword:
      case Items.goldenSword:
        return const ItemData(tool: Tools.sword);
      case Items.woodenShovel:
      case Items.stoneShovel:
      case Items.ironShovel:
      case Items.diamondShovel:
      case Items.goldenShovel:
        return const ItemData(tool: Tools.shovel);
      case Items.woodenPickaxe:
      case Items.stonePickaxe:
      case Items.ironPickaxe:
      case Items.diamondPickaxe:
      case Items.goldenPickaxe:
        return const ItemData(tool: Tools.pickaxe);
      case Items.woodenAxe:
      case Items.stoneAxe:
      case Items.ironAxe:
      case Items.diamondAxe:
      case Items.goldenAxe:
        return const ItemData(tool: Tools.axe);
      case Items.apple:
        return const ItemData(isFood: true);
      default:
        return const ItemData();
    }
  }
}
