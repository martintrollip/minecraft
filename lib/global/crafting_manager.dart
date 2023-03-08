import 'package:get/get.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/items.dart';

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

  Recipe stickRecipeStandardGrid = Recipe(
    recipe: RegExp(r'^E*WEEWE*$'),
    product: Items.stick,
    count: 4,
    key: {Blocks.birchLog: "W"},
  );

  Recipe stickRecipePlayerGrid = Recipe(
    recipe: RegExp(r'^E*WEWE*$'),
    product: Items.stick,
    count: 4,
    key: {Blocks.birchLog: "W"},
  );

  void checkForRecipe() {
    if (isOpen.value) {
      // Crafting table recipe
      if (stickRecipeStandardGrid.isMatch(standardCraftingGrid)) {
        standardCraftingGrid.last.block = stickRecipeStandardGrid.product;
        standardCraftingGrid.last.count.value = stickRecipeStandardGrid.count;
        return;
      }
    } else {
      // Player crafting recipe
      if (stickRecipePlayerGrid.isMatch(playerCraftingGrid)) {
        playerCraftingGrid.last.block = stickRecipePlayerGrid.product;
        playerCraftingGrid.last.count.value = stickRecipePlayerGrid.count;
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

class Recipe {
  const Recipe({
    required this.recipe,
    required this.product,
    required this.count,
    required this.key,
  });

  final RegExp recipe;
  final dynamic product;
  final int count;
  final Map key;

  String _craftingGridToString(List<InventorySlot> slots) {
    String result = "";
    // take all but the last slot since the last slot is output
    for (var i = 0; i < slots.length - 1; i++) {
      if (slots[i].block != null) {
        result += key[slots[i].block] ?? "E";
      } else {
        result += "E";
      }
    }
    return result;
  }

  bool isMatch(List<InventorySlot> input) {
    return recipe.hasMatch(_craftingGridToString(input));
  }
}
