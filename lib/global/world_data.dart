import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constant.dart';
import 'package:minecraft/utils/game_methods.dart';

class WorldData {
  WorldData({required this.seed});

  final int seed;

  var playerData = PlayerData();

  var leftWorldChunks = List.generate(chunkHeight, (index) => <Blocks?>[]);

  var rightWorldChunks = List.generate(chunkHeight, (index) => <Blocks?>[]);

  List<int> get chunksToRender {
    return [
      GameMethods.instance.playerChunk,
      GameMethods.instance.playerChunk + 1,
      GameMethods.instance.playerChunk - 1,
      // GameMethods.instance.playerChunk + 2,
      // GameMethods.instance.playerChunk - 2,
      // GameMethods.instance.playerChunk - 3,
      // GameMethods.instance.playerChunk + 3,
    ];
  }

  List<int> visibleChunks = [];

  List<ItemComponent> items = [];

  InventoryManager inventoryManager = InventoryManager();
}
