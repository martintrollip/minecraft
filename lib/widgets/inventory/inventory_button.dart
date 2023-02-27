import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';

class InventoryButton extends StatelessWidget {
  const InventoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GlobalGameReference.instance.game.worldData.inventoryManager.toggle();
      },
      child: SizedBox.square(
        dimension: GameMethods.instance.inventorySlotSize,
        child: FittedBox(
          child: Image.asset('assets/images/inventory/inventory_button.png'),
        ),
      ),
    );
  }
}
