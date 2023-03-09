/*If player is holding a suitable tool for the given block, then return a mining speed that is 10% faster than the base mining speed of the block. */
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/items.dart';

import 'blocks.dart';

const woodenTools = [
  Items.woodenPickaxe,
  Items.woodenAxe,
  Items.woodenShovel,
  Items.woodenSword,
];

const stoneTools = [
  Items.stonePickaxe,
  Items.stoneAxe,
  Items.stoneShovel,
  Items.stoneSword,
];

const ironTools = [
  Items.ironPickaxe,
  Items.ironAxe,
  Items.ironShovel,
  Items.ironSword,
];

const diamondTools = [
  Items.diamondPickaxe,
  Items.diamondAxe,
  Items.diamondShovel,
  Items.diamondSword,
];

const goldTools = [
  Items.goldenPickaxe,
  Items.goldenAxe,
  Items.goldenShovel,
  Items.goldenSword,
];

double getMiningSpeedFor(Blocks block) {
  final selection = GlobalGameReference.instance.game.worldData.inventoryManager
      .getSelectedBlock();
  final suitableTool = BlockData.getFor(block).suitableTool;
  final base = BlockData.getFor(block).baseMiningSpeed;

  //TODO mull check maybe
  if (selection is Items &&
      ItemData.from(item: selection).tool == suitableTool) {
    if (woodenTools.contains(selection)) {
      return base * 0.9;
    } else if (stoneTools.contains(selection)) {
      return base * 0.8;
    } else if (ironTools.contains(selection)) {
      return base * 0.7;
    } else if (diamondTools.contains(selection)) {
      return base * 0.6;
    } else if (goldTools.contains(selection)) {
      return base * 0.5;
    }
  }
  return base;
}
