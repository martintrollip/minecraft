import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';

class PlayerInventoryWidget extends StatelessWidget {
  const PlayerInventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!GlobalGameReference
          .instance.game.worldData.inventoryManager.isOpen.value) {
        return const SizedBox.shrink();
      }

      return Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              const InventoryStorage(),
              Positioned(
                top: GameMethods.instance.inventorySlotSize / 2,
                left: GameMethods.instance.inventorySlotSize / 4,
                right: GameMethods.instance.inventorySlotSize / 4,
                child: Container(
                  height: GameMethods.instance.inventorySlotSize * 3.6,
                  width: GameMethods.instance.inventorySlotSize * 9,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
