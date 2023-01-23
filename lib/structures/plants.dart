import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/structures.dart';

const cactus = Structure(
  structure: [
    [Blocks.cactus],
    [Blocks.cactus],
  ],
  maxOccurrences: 5,
  maxWidth: 1,
);

const deadBush = Structure(
  structure: [
    [Blocks.deadBush],
  ],
  maxOccurrences: 3,
  maxWidth: 1,
);

final purpleFlower = Structure.plant(Blocks.purpleFlower);
final drippingWhiteFlower = Structure.plant(Blocks.drippingWhiteFlower);
final redFlower = Structure.plant(Blocks.redFlower);
final whiterFlower = Structure.plant(Blocks.whiterFlower);
final yellowFlower = Structure.plant(Blocks.yellowFlower);
