import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';

class InventorySlotBackground extends StatelessWidget {
  const InventorySlotBackground(this._type, {super.key});

  final SlotType _type;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
        dimension: GameMethods.instance.inventorySlotSize,
        child: FittedBox(child: Image.asset(getPath())));
  }

  String getPath() {
    switch (_type) {
      case SlotType.inventory:
        return 'assets/images/inventory/inventory_item_storage_slot.png';
      case SlotType.itemBar:
        return 'assets/images/inventory/inventory_item_bar_slot.png';
    }
  }
}
