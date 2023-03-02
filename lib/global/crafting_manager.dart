import 'package:get/get.dart';
import 'package:minecraft/global/inventory_manager.dart';

class CraftingManger {
  Rx<bool> isOpen = false.obs;

  List<InventorySlot> playerCraftingGrid = List.generate(
    5,
    (index) => InventorySlot(index: index),
  );

  List<InventorySlot> standardCraftingGrid = List.generate(
    10,
    (index) => InventorySlot(index: index),
  );

  void toggle() {
    isOpen.value = !isOpen.value;
  }

  void close() {
    isOpen.value = false;
  }
}
