import 'package:minecraft/resources/blocks.dart';

class Ore {
  Ore({required this.block, required this.rarity});

  final Blocks block;
  final int rarity;

  factory Ore.iron() => Ore(block: Blocks.ironOre, rarity: 65);
  factory Ore.coal() => Ore(block: Blocks.coalOre, rarity: 65);
  factory Ore.gold() => Ore(block: Blocks.goldOre, rarity: 55);
  factory Ore.diamond() => Ore(block: Blocks.diamondOre, rarity: 45);
}
