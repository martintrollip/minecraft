import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:minecraft/resources/biomes.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/ores.dart';
import 'package:minecraft/resources/structures.dart';
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
    chunk = _addStructures(biome, chunk, yValues, seed + chunkIndex);
    chunk = _addOre(chunk, Ore.iron(), seed + 101);
    chunk = _addOre(chunk, Ore.coal(), seed + 111);
    chunk = _addOre(chunk, Ore.gold(), seed + 121);
    chunk = _addOre(chunk, Ore.diamond(), seed + 131);

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

  List<List<Blocks?>> _addStructures(
    BiomeData biome,
    List<List<Blocks?>> chunk,
    List<int> yValues,
    int seed,
  ) {
    biome.structures.asMap().forEach((key, structure) {
      int count = Random(seed).nextInt(structure.maxOccurrences + 1);
      for (var i = 0; i < count; i++) {
        _addStructure(chunk, yValues, seed + i + key, structure);
      }
    });
    return chunk;
  }

  List<List<Blocks?>> _addStructure(
    List<List<Blocks?>> chunk,
    List<int> yValues,
    int seed,
    Structure tree,
  ) {
    final xStart = Random(seed).nextInt(chunkWidth - tree.maxWidth);
    final xStump = xStart + (tree.maxWidth ~/ 2);
    final yStart = yValues[xStump] - 1;
    final height = tree.structure.length;
    final structure = tree.structure.reversed.toList();

    for (int rowIndex = 0; rowIndex < height; rowIndex++) {
      final row = structure[rowIndex];

      row.asMap().forEach((index, blocks) {
        final yCurrent = yStart - rowIndex;
        final xCurrent = xStart + index;
        if (chunk[yCurrent][xCurrent] == null) {
          chunk[yCurrent][xCurrent] = blocks;
        }
      });
    }

    return chunk;
  }

  List<int> getYValuesFromNoise(List<List<double>> noise) {
    return noise
        .map((e) => (e[0] * 10).toInt().abs() + GameMethods.instance.freeArea)
        .toList();
  }

  List<List<Blocks?>> _addOre(List<List<Blocks?>> chunk, Ore ore, int seed) {
    var raw = noise2(
      chunkWidth,
      chunkHeight,
      noiseType: NoiseType.Perlin,
      frequency: 0.1,
      seed: seed,
    );

    var processed = GameMethods.instance.processNoise(raw);
    processed.asMap().forEach((rowIndex, row) {
      row.asMap().forEach((index, value) {
        if (value < ore.rarity && chunk[index][rowIndex] == Blocks.stone) {
          chunk[index][rowIndex] = ore.block;
        }
      });
    });

    return chunk;
  }
}
