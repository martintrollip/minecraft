import 'blocks.dart';

enum Biomes { desert, birchForest }

class BiomeData {
  BiomeData({required this.primarySoil, required this.secondarySoil});

  final Blocks primarySoil;
  final Blocks secondarySoil;

  factory BiomeData.from(Biomes biome) {
    switch (biome) {
      case Biomes.desert:
        return BiomeData.desert();
      case Biomes.birchForest:
        return BiomeData.birchForest();
    }
  }

  factory BiomeData.desert() {
    return BiomeData(primarySoil: Blocks.sand, secondarySoil: Blocks.sand);
  }

  factory BiomeData.birchForest() {
    return BiomeData(primarySoil: Blocks.grass, secondarySoil: Blocks.dirt);
  }
}
