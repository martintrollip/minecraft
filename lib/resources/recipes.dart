import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/resources/items.dart';

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

  static List<Recipe> playerInventoryGridRecipe = [
    //dead bush stick
    Recipe(
        recipe: RegExp("^E*SE*\$"),
        key: {Blocks.deadBush: "S"},
        product: Items.stick,
        count: 1),

    //stick
    Recipe(
        recipe: RegExp("^E*WEWE*\$"),
        product: Items.stick,
        count: 4,
        key: {Blocks.birchPlank: "W"}),

    //birch planks
    Recipe(
        recipe: RegExp("^E*WE*\$"),
        key: {Blocks.birchLog: "W"},
        product: Blocks.birchPlank,
        count: 4),

    //crafting table
    Recipe(
        recipe: RegExp("^E*BBBBE*\$"),
        key: {Blocks.birchPlank: "B"},
        product: Blocks.craftingTable,
        count: 1),
  ];

  static List standardGridRecipe = [
    //dead bush stick
    Recipe(
        recipe: RegExp("^E*SE*\$"),
        key: {Blocks.deadBush: "S"},
        product: Items.stick,
        count: 1),

/*     //stick for standardGrid
    Recipe(
        recipe: RegExp("^E*WEEWE*\$"),
        key: {Blocks.birchPlank: "W"},
        product: Items.stick,
        count: 4), */

    //birch planks
    Recipe(
        recipe: RegExp("^E*WE*\$"),
        key: {Blocks.birchLog: "W"},
        product: Blocks.birchPlank,
        count: 4),

    //crafting table
    Recipe(
        recipe: RegExp("^E*BBEBBEE*\$"),
        key: {Blocks.birchPlank: "B"},
        product: Blocks.craftingTable,
        count: 1),

    //wooden sword
    Recipe(
        recipe: RegExp("^E*WEEWEESE*\$"),
        key: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenSword,
        count: 1),

    //wooden shovel
    Recipe(
        recipe: RegExp("^E*WEESEESE*\$"),
        key: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenShovel,
        count: 1),

    //wooden pickaxe
    Recipe(
        recipe: RegExp("WWWESEESE"),
        key: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenPickaxe,
        count: 1),

    //wooden axe
    Recipe(
        recipe: RegExp("^E*WWESWESE*\$"),
        key: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenAxe,
        count: 1),

    //Stone sword
    Recipe(
        recipe: RegExp("^E*CEECEESE*\$"),
        key: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneSword,
        count: 1),

    //stone shovel
    Recipe(
        recipe: RegExp("^E*CEESEESE*\$"),
        key: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneShovel,
        count: 1),

    //stone pickaxe
    Recipe(
        recipe: RegExp("CCCESEESE"),
        key: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stonePickaxe,
        count: 1),

    //stone axe
    Recipe(
        recipe: RegExp("^E*CCESCESE*\$"),
        key: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneAxe,
        count: 1),

    //iron sword
    Recipe(
        recipe: RegExp("^E*IEEIEESE*\$"),
        key: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironSword,
        count: 1),

    //iron shovel
    Recipe(
        recipe: RegExp("^E*IEESEESE*\$"),
        key: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironShovel,
        count: 1),

    //iron pickaxe
    Recipe(
        recipe: RegExp("IIIESEESE"),
        key: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironPickaxe,
        count: 1),

    //iron axe
    Recipe(
        recipe: RegExp("^E*IIESIESE*\$"),
        key: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironAxe,
        count: 1),

    //gold sword
    Recipe(
        recipe: RegExp("^E*GEEGEESE*\$"),
        key: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenSword,
        count: 1),

    //gold shovel
    Recipe(
        recipe: RegExp("^E*GEESEESE*\$"),
        key: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenShovel,
        count: 1),

    //gold pickaxe
    Recipe(
        recipe: RegExp("GGGESEESE"),
        key: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenPickaxe,
        count: 1),

    //gold axe
    Recipe(
        recipe: RegExp("^E*GGESGESE*\$"),
        key: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenAxe,
        count: 1),

    //diamond sword
    Recipe(
        recipe: RegExp("^E*DEEDEESE*\$"),
        key: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondSword,
        count: 1),

    //diamond shovel
    Recipe(
        recipe: RegExp("^E*DEESEESE*\$"),
        key: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondShovel,
        count: 1),

    //diamond pickaxe
    Recipe(
        recipe: RegExp("DDDESEESE"),
        key: {Items.diamondAxe: "D", Items.stick: "S"},
        product: Items.diamondPickaxe,
        count: 1),

    //diamond axe
    Recipe(
        recipe: RegExp("^E*DDESDESE*\$"),
        key: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondAxe,
        count: 1),
  ];
}
