import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';
import 'package:minecraft/widgets/inventory/item_bar.dart';

class InventoryStorage extends StatelessWidget {
  const InventoryStorage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getDragTarget(Direction.left),
        SizedBox.square(
          dimension: GameMethods.instance.screenSize().height * 0.8,
          child: FittedBox(
            child: Stack(children: [
              Image.asset('assets/images/inventory/inventory_background.png'),
              Positioned(
                left: GameMethods.instance.inventorySlotSize / 4,
                right: GameMethods.instance.inventorySlotSize / 4,
                bottom: GameMethods.instance.inventorySlotSize / 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ItemBar(SlotType.inventory, startIndex: 27),
                    const ItemBar(SlotType.inventory, startIndex: 18),
                    const ItemBar(SlotType.inventory, startIndex: 9),
                    SizedBox(
                        height: GameMethods.instance.inventorySlotSize / 4),
                    const ItemBar(SlotType.inventory),
                  ],
                ),
              ),
            ]),
          ),
        ),
        _getDragTarget(Direction.right),
      ],
    );
  }

  Widget _getDragTarget(Direction direction) {
    return Expanded(
      child: DragTarget(
        builder: (_, __, ___) => Container(),
        onAccept: (InventorySlot data) {
          final xDelta = (direction == Direction.left ? -1 : 1) * 5 +
              (Random().nextBool() ? 1 : -1);
          const yDelta = -3;
          final position = Vector2(
            GameMethods.instance.playerIndex.x + xDelta,
            GameMethods.instance.playerIndex.y + yDelta,
          );

          GlobalGameReference.instance.game.worldData.items.addAll(
            List.generate(
              data.count.value,
              (_) => ItemComponent(position, data.block!),
            ),
          );

          GlobalGameReference.instance.game.worldData.inventoryManager
              .removeItem(data, count: data.count.value);
        },
      ),
    );
  }
}
