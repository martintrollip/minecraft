import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_widget.dart';

class StandardCrafting extends StatelessWidget {
  const StandardCrafting({super.key});

  @override
  Widget build(BuildContext context) {
    final grid = GlobalGameReference
        .instance.game.worldData.craftingManger.standardCraftingGrid;
    final slotSize = GameMethods.instance.inventorySlotSize;
    return SizedBox(
      height: GameMethods.instance.inventorySlotSize * 4.4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //3x3 crafting grid
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                InventorySlotWidget(SlotType.crafting, grid[0]),
                InventorySlotWidget(SlotType.crafting, grid[1]),
                InventorySlotWidget(SlotType.crafting, grid[2]),
              ]),
              Row(children: [
                InventorySlotWidget(SlotType.crafting, grid[3]),
                InventorySlotWidget(SlotType.crafting, grid[4]),
                InventorySlotWidget(SlotType.crafting, grid[5]),
              ]),
              Row(children: [
                InventorySlotWidget(SlotType.crafting, grid[6]),
                InventorySlotWidget(SlotType.crafting, grid[7]),
                InventorySlotWidget(SlotType.crafting, grid[8]),
              ]),
            ],
          ),
          Image.asset(
            'assets/images/inventory/inventory_arrow.png',
            width: slotSize,
            height: slotSize,
          ),
          InventorySlotWidget(SlotType.craftingOutput, grid[9]),
        ],
      ),
    );
  }
}
