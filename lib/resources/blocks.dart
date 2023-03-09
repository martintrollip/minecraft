import 'package:flame/components.dart';
import 'package:minecraft/blocks/crafting_table_block.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/resources/items.dart';

enum Blocks {
  grass,
  dirt,
  stone,
  birchLog,
  birchLeaf,
  cactus,
  deadBush,
  sand,
  coalOre,
  ironOre,
  diamondOre,
  goldOre,
  grassPlant,
  redFlower,
  purpleFlower,
  drippingWhiteFlower,
  yellowFlower,
  whiterFlower,
  birchPlank,
  craftingTable,
  cobblestone,
  bedrock
}

class BlockData {
  final bool isCollidable;
  final double baseMiningSpeed;
  final bool breakable;
  final Tools suitableTool;

  BlockData({
    required this.isCollidable,
    required this.baseMiningSpeed,
    this.breakable = true,
    required this.suitableTool,
  });

  factory BlockData.getFor(Blocks block) {
    switch (block) {
      case Blocks.deadBush:
      case Blocks.grassPlant:
      case Blocks.redFlower:
      case Blocks.purpleFlower:
      case Blocks.drippingWhiteFlower:
      case Blocks.yellowFlower:
      case Blocks.whiterFlower:
        return plants;
      case Blocks.birchLeaf:
      case Blocks.cactus:
        return leaf;
      case Blocks.sand:
        return sand;
      case Blocks.grass:
      case Blocks.dirt:
        return soil;
      case Blocks.birchLog:
        return wood;
      case Blocks.craftingTable:
      case Blocks.birchPlank:
        return woodPlank;
      case Blocks.stone:
      case Blocks.cobblestone:
      case Blocks.coalOre:
        return stone;
      case Blocks.ironOre:
      case Blocks.diamondOre:
      case Blocks.goldOre:
        return ore;
      case Blocks.bedrock:
        return bedrock;
    }
  }

  static BlockComponent getParentForBlock({
    required Blocks block,
    required Vector2 index,
    required int chunkIndex,
  }) {
    switch (block) {
      case Blocks.craftingTable:
        return CraftingTableBlock(
            block: block, index: index, chunkIndex: chunkIndex);
      default:
        return BlockComponent(
            block: block, index: index, chunkIndex: chunkIndex);
    }
  }

  static BlockData plants = BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.5,
    suitableTool: Tools.none,
  );

  static BlockData leaf = BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.5,
    suitableTool: Tools.none,
  );

  static BlockData sand = BlockData(
      isCollidable: true, baseMiningSpeed: 0.5, suitableTool: Tools.shovel);

  static BlockData soil = BlockData(
      isCollidable: true, baseMiningSpeed: 0.75, suitableTool: Tools.shovel);

  static BlockData wood = BlockData(
      isCollidable: false, baseMiningSpeed: 1.25, suitableTool: Tools.axe);

  static BlockData woodPlank = BlockData(
      isCollidable: true, baseMiningSpeed: 1.5, suitableTool: Tools.axe);

  static BlockData stone = BlockData(
      isCollidable: true, baseMiningSpeed: 2, suitableTool: Tools.pickaxe);

  static BlockData ore = BlockData(
      isCollidable: true, baseMiningSpeed: 2.5, suitableTool: Tools.pickaxe);

  static BlockData bedrock = BlockData(
      isCollidable: true,
      baseMiningSpeed: 100,
      breakable: false,
      suitableTool: Tools.none);
}
