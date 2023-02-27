import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/widgets/crafting/standard_crafting.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';

class CraftingInventoryWidget extends StatelessWidget {
  const CraftingInventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!GlobalGameReference
          .instance.game.worldData.craftingManger.isOpen.value) {
        return const SizedBox.shrink();
      }

      return const Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: InventoryStorage(StandardCrafting()),
        ),
      );
    });
  }
}
