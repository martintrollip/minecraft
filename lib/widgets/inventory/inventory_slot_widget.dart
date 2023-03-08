import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory_manager.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_background.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';

class InventorySlotWidget extends StatelessWidget {
  const InventorySlotWidget(this._type, this._slot, {super.key});

  final SlotType _type;
  final InventorySlot _slot;

  @override
  Widget build(BuildContext context) {
    if (_type == SlotType.itemBar || _type == SlotType.craftingOutput) {
      return getChild();
    }

    return Draggable(
      data: _slot,
      feedback: BlocKDrag(_slot),
      childWhenDragging: InventorySlotBackground(_type,
          isSelected: GlobalGameReference.instance.game.worldData
                  .inventoryManager.currentSelection.value ==
              _slot.index),
      child: getChild(),
    );
  }

  Widget getChild() {
    return GestureDetector(
      onLongPress: () {
        if (_type == SlotType.inventory || _type == SlotType.crafting) {
          if (_slot.count.value > 1) {
            int half = (_slot.count.value / 2).floor();
            _slot.count.value -= half;
            GlobalGameReference.instance.game.worldData.inventoryManager
                .addItem(
              _slot.block!,
              count: half,
              split: true,
            );
          }
        }
      },
      onTap: () {
        if (_type == SlotType.itemBar) {
          GlobalGameReference.instance.game.worldData.inventoryManager
              .currentSelection.value = _slot.index;
        }

        if (_type == SlotType.craftingOutput) {
          final standardGrid = GlobalGameReference
              .instance.game.worldData.craftingManger.standardCraftingGrid;

          GlobalGameReference.instance.game.worldData.craftingManger
              .decrementCurrentInventory();
          // and also when dragging out from crafting output
        }

        if (_type == SlotType.craftingOutput || _type == SlotType.crafting) {
          GlobalGameReference.instance.game.worldData.inventoryManager
              .addItem(_slot.block!, count: _slot.count.value);
          _slot.emptySlot();

          GlobalGameReference.instance.game.worldData.craftingManger
              .checkForRecipe();
        }
      },
      child: Obx(() {
        return Stack(
          children: [
            InventorySlotBackground(_type,
                isSelected: GlobalGameReference.instance.game.worldData
                        .inventoryManager.currentSelection.value ==
                    _slot.index),
            if (_slot.count.value > 0) ...[
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(
                      GameMethods.instance.inventorySlotSize / 4),
                  child: SpriteWidget(
                      sprite: GameMethods.instance.getSprite(_slot.block!)),
                ),
              ),
              //add counter with minecraft font
              Positioned(
                bottom: GameMethods.instance.inventorySlotSize / 6,
                right: GameMethods.instance.inventorySlotSize / 6,
                child: Text(
                  _slot.count.value.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: GameMethods.instance.inventorySlotSize / 4,
                      fontFamily: 'MinecraftFont',
                      shadows: const [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black,
                          offset: Offset(1, 1),
                        ),
                      ]),
                ),
              ),
            ] else ...[
              const SizedBox.shrink()
            ],
            if (_type != SlotType.craftingOutput) getDragTarget(),
          ],
        );
      }),
    );
  }

  Widget getDragTarget() {
    return DragTarget(
      builder: (_, __, ___) {
        return SizedBox.square(
          dimension: GameMethods.instance.inventorySlotSize,
        );
      },
      onAccept: (InventorySlot data) {
        if (_slot.isEmpty) {
          _slot.block = data.block;
          _slot.count.value = data.count.value;
          data.emptySlot();
        } else if (_slot.block == data.block) {
          int freeSpace = _slot.freeSpace();

          if (freeSpace > 0) {
            if (freeSpace >= data.count.value) {
              _slot.count.value += data.count.value;
              data.emptySlot();
            } else {
              _slot.count.value += freeSpace;
              data.count.value -= freeSpace;
            }
          }
        }

        // Always check for recipe
        GlobalGameReference.instance.game.worldData.craftingManger
            .checkForRecipe();
      },
    );
  }
}

class BlocKDrag extends StatelessWidget {
  const BlocKDrag(InventorySlot slot, {super.key}) : _slot = slot;

  final InventorySlot _slot;

  @override
  Widget build(BuildContext context) {
    if (_slot.block == null) {
      return const SizedBox.shrink();
    }

    return Stack(children: [
      Padding(
        padding: EdgeInsets.all(GameMethods.instance.inventorySlotSize / 4),
        child:
            SpriteWidget(sprite: GameMethods.instance.getSprite(_slot.block!)),
      ),
      Positioned(
        bottom: GameMethods.instance.inventorySlotSize / 6,
        right: GameMethods.instance.inventorySlotSize / 6,
        child: Text(
          _slot.count.value.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: GameMethods.instance.inventorySlotSize / 4,
              fontFamily: 'MinecraftFont',
              shadows: const [
                Shadow(
                  blurRadius: 1,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ]),
        ),
      ),
    ]);
  }
}
