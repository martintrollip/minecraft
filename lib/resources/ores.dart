import 'package:minecraft/resources/blocks.dart';

class Ore {
  const Ore({required this.block, required this.rarity});

  final Blocks block;
  final int rarity;

  static const iron = Ore(block: Blocks.ironOre, rarity: 65);
  static const coal = Ore(block: Blocks.coalOre, rarity: 65);
  static const gold = Ore(block: Blocks.goldOre, rarity: 55);
  static const diamond = Ore(block: Blocks.diamondOre, rarity: 45);
}
