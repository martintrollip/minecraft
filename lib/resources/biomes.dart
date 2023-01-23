import 'package:minecraft/resources/structures.dart';
import 'package:minecraft/structures/plants.dart';
import 'package:minecraft/structures/trees.dart';

import 'blocks.dart';

enum Biomes { desert, birchForest }

class BiomeData {
  BiomeData(
      {required this.primarySoil,
      required this.secondarySoil,
      required this.structures});

  final Blocks primarySoil;
  final Blocks secondarySoil;
  final List<Structure> structures;

  factory BiomeData.from(Biomes biome) {
    switch (biome) {
      case Biomes.desert:
        return BiomeData.desert();
      case Biomes.birchForest:
        return BiomeData.birchForest();
    }
  }

  factory BiomeData.desert() {
    return BiomeData(
      primarySoil: Blocks.sand,
      secondarySoil: Blocks.sand,
      structures: [cactus, deadBush],
    );
  }

  factory BiomeData.birchForest() {
    return BiomeData(
      primarySoil: Blocks.grass,
      secondarySoil: Blocks.dirt,
      structures: [
        birchTree,
        redFlower,
        purpleFlower,
        drippingWhiteFlower,
        redFlower,
        whiterFlower,
        yellowFlower,
      ],
    );
  }
}
