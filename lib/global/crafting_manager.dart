import 'package:get/get.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/items.dart';
import 'package:minecraft/resources/recipes.dart';

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
    checkForRecipe();
  }

  void close() {
    isOpen.value = false;
  }

  void checkForRecipe() {
    if (isOpen.value) {
      // Crafting table recipe
      final match = Recipe.standardGridRecipe
          .firstWhereOrNull((recipe) => recipe.isMatch(standardCraftingGrid));
      if (match != null) {
        standardCraftingGrid.last.block = match.product;
        standardCraftingGrid.last.count.value = match.count;
        return;
      }
    } else {
      // Player crafting recipe
      final match = Recipe.playerInventoryGridRecipe
          .firstWhereOrNull((recipe) => recipe.isMatch(playerCraftingGrid));
      if (match != null) {
        playerCraftingGrid.last.block = match.product;
        playerCraftingGrid.last.count.value = match.count;
        return;
      }
    }

    standardCraftingGrid.last.emptySlot();
    playerCraftingGrid.last.emptySlot();
  }

  void decrementCurrentInventory() {
    var slots = isOpen.value ? standardCraftingGrid : playerCraftingGrid;
    for (var slot in slots.take(slots.length - 1).toList()) {
      if (!slot.isEmpty) {
        slot.count.value--;

        if (slot.count.value == 0) {
          slot.emptySlot();
        }
      }
    }
  }
}
