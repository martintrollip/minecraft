import 'package:minecraft/global/inventory_manager.dart';

class CraftingManger {
  List<InventorySlot> playerCraftingGrid = List.generate(
    5,
    (index) => InventorySlot(index: index),
  );
}
