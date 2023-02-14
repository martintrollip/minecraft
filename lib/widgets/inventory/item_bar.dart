import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_widget.dart';

import 'inventory_slot_type.dart';

class ItemBar extends StatelessWidget {
  const ItemBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(GameMethods.instance.inventorySlotSize / 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(SlotType.itemBar, _slot(0)),
            InventorySlotWidget(SlotType.itemBar, _slot(1)),
            InventorySlotWidget(SlotType.itemBar, _slot(2)),
            InventorySlotWidget(SlotType.itemBar, _slot(3)),
            InventorySlotWidget(SlotType.itemBar, _slot(4)),
            InventorySlotWidget(SlotType.itemBar, _slot(5)),
            InventorySlotWidget(SlotType.itemBar, _slot(6)),
            InventorySlotWidget(SlotType.itemBar, _slot(7)),
            InventorySlotWidget(SlotType.itemBar, _slot(8)),
          ],
        ),
      ),
    );
  }

  InventorySlot _slot(int index) {
    return GlobalGameReference
        .instance.game.worldData.inventoryManager.items[index];
  }
}
