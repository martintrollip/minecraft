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

  BlockData({
    required this.isCollidable,
    required this.baseMiningSpeed,
    this.breakable = true,
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
      case Blocks.sand:
      case Blocks.birchLeaf:
      case Blocks.cactus:
        return leaf;
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

  static BlockData plants = BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.5,
  );

  static BlockData leaf = BlockData(
    isCollidable: false,
    baseMiningSpeed: 0.5,
  );

  static BlockData soil = BlockData(
    isCollidable: true,
    baseMiningSpeed: 0.75,
  );

  static BlockData wood = BlockData(
    isCollidable: false,
    baseMiningSpeed: 1.25,
  );

  static BlockData woodPlank = BlockData(
    isCollidable: true,
    baseMiningSpeed: 1.5,
  );

  static BlockData stone = BlockData(
    isCollidable: true,
    baseMiningSpeed: 2,
  );

  static BlockData ore = BlockData(
    isCollidable: true,
    baseMiningSpeed: 2.5,
  );

  static BlockData bedrock = BlockData(
    isCollidable: true,
    baseMiningSpeed: 100,
    breakable: false,
  );
}
