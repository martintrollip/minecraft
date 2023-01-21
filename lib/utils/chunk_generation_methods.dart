import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:minecraft/resources/biomes.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

  List<List<Blocks?>> generateEmptyChunks() {
    return List.generate(
      chunkHeight,
      (row) => List.generate(chunkWidth, (column) => null),
    );
  }

  List<List<Blocks?>> generateChunks(int chunkIndex) {
    final seed = GameMethods.instance.seed(chunkIndex);
    final startIndex = GameMethods.instance.getStartIndex(chunkIndex);
    final endIndex = GameMethods.instance.getEndIndex(chunkIndex);

    BiomeData biome =
        Random(seed).nextBool() ? BiomeData.desert() : BiomeData.birchForest();
    var chunk = generateEmptyChunks();

    final noiseRange = noise2(
      endIndex,
      1,
      noiseType: NoiseType.Perlin,
      frequency: 0.05,
      seed: seed,
    );

    final noise = noiseRange.sublist(startIndex, endIndex);

    final yValues = chunkIndex >= 0
        ? getYValuesFromNoise(noise)
        : getYValuesFromNoise(noise.reversed.toList());

    chunk = _generatePrimarySoil(yValues, chunk, biome.primarySoil);
    chunk = _generateSecondarySoil(yValues, chunk, biome.secondarySoil);
    chunk = _generateStone(chunk, Blocks.stone, seed);

    //TODO for debugging
    if (chunkIndex == -2) {
      chunk[0][0] = Blocks.grass;
    }
    if (chunkIndex == -1) {
      chunk[0][0] = Blocks.dirt;
    }
    if (chunkIndex == 0) {
      chunk[0][0] = Blocks.stone;
    }
    if (chunkIndex == 1) {
      chunk[0][0] = Blocks.sand;
    }
    if (chunkIndex == 2) {
      chunk[0][0] = Blocks.redFlower;
    }

    return chunk;
  }

  List<List<Blocks?>> _generatePrimarySoil(
      List<int> yValues, List<List<Blocks?>> chunk, Blocks block) {
    yValues.asMap().forEach((index, value) {
      chunk[value][index] = block;
    });

    return chunk;
  }

  List<List<Blocks?>> _generateSecondarySoil(
      List<int> yValues, List<List<Blocks?>> chunk, Blocks block) {
    yValues.asMap().forEach((index, value) {
      for (int i = value + 1;
          i <= GameMethods.instance.maxSecondarySoilDepth;
          i++) {
        chunk[i][index] = block;
      }
    });

    return chunk;
  }

  List<List<Blocks?>> _generateStone(
      List<List<Blocks?>> chunk, Blocks block, seed) {
    for (int column = 0; column < chunkWidth; column++) {
      for (int row = GameMethods.instance.maxSecondarySoilDepth + 1;
          row < chunk.length;
          row++) {
        chunk[row][column] = block;
      }
    }

    int x1 = Random(seed).nextInt(chunkWidth ~/ 2);
    int x2 = x1 + Random(seed).nextInt(chunkWidth ~/ 2);

    chunk[GameMethods.instance.maxSecondarySoilDepth].fillRange(x1, x2, block);

    return chunk;
  }

  List<int> getYValuesFromNoise(List<List<double>> noise) {
    return noise
        .map((e) => (e[0] * 10).toInt().abs() + GameMethods.instance.freeArea)
        .toList();
  }
}
