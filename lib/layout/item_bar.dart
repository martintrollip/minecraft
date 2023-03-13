import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_button.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_widget.dart';

import '../widgets/inventory/inventory_slot_type.dart';

class ItemBar extends StatelessWidget {
  const ItemBar(SlotType type, {int startIndex = 0, super.key})
      : _type = type,
        _startIndex = startIndex;

  final SlotType _type;
  final int _startIndex;

  @override
  Widget build(BuildContext context) {
    final isBar = _type == SlotType.itemBar;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: isBar
            ? EdgeInsets.all(GameMethods.instance.inventorySlotSize / 4)
            : EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(_type, _slot(_startIndex + 0)),
            InventorySlotWidget(_type, _slot(_startIndex + 1)),
            InventorySlotWidget(_type, _slot(_startIndex + 2)),
            InventorySlotWidget(_type, _slot(_startIndex + 3)),
            InventorySlotWidget(_type, _slot(_startIndex + 4)),
            InventorySlotWidget(_type, _slot(_startIndex + 5)),
            InventorySlotWidget(_type, _slot(_startIndex + 6)),
            InventorySlotWidget(_type, _slot(_startIndex + 7)),
            InventorySlotWidget(_type, _slot(_startIndex + 8)),
            if (isBar) const InventoryButton(),
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
