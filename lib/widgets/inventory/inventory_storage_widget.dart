import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';
import 'package:minecraft/widgets/inventory/item_bar.dart';

class InventoryStorage extends StatelessWidget {
  const InventoryStorage({super.key});

  @override
  Widget build(BuildContext context) {
    double size = GameMethods.instance.inventorySlotSize * 9 +
        (GameMethods.instance.inventorySlotSize / 2);

    return SizedBox.square(
      dimension: size,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/images/inventory/inventory_background.png'),
        Positioned(
          left: GameMethods.instance.inventorySlotSize / 4,
          bottom: GameMethods.instance.inventorySlotSize / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ItemBar(SlotType.inventory, startIndex: 27),
              const ItemBar(SlotType.inventory, startIndex: 18),
              const ItemBar(SlotType.inventory, startIndex: 9),
              SizedBox(height: GameMethods.instance.inventorySlotSize / 4),
              const ItemBar(SlotType.inventory),
            ],
          ),
        ),
      ]),

      //add slots
    );
  }
}
