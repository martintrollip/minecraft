import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';

class InventorySlotBackground extends StatelessWidget {
  const InventorySlotBackground(this._type,
      {bool isSelected = false, super.key})
      : _isSelected = isSelected;

  final SlotType _type;
  final bool _isSelected;

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
        if (_isSelected) {
          return 'assets/images/inventory/inventory_active_slot.png';
        }
        return 'assets/images/inventory/inventory_item_bar_slot.png';
    }
  }
}
