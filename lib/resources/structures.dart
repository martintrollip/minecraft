import 'package:minecraft/resources/blocks.dart';

class Structure {
  const Structure({
    required this.structure,
    required this.maxOccurrences,
    required this.maxWidth,
  });

  factory Structure.plant(Blocks block) => Structure(
        structure: [
          [block]
        ],
        maxOccurrences: 3,
        maxWidth: 1,
      );

  final List<List<Blocks?>> structure;
  final int maxOccurrences;
  final int maxWidth;
}
