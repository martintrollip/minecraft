import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/layout/controller_widget.dart';
import 'package:minecraft/main_game.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_type.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';
import 'package:minecraft/widgets/inventory/item_bar.dart';
import 'package:minecraft/widgets/inventory/player_inventory.dart';

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(
          game: MainGame(
            worldData: WorldData(seed: 9322), //1232114
            // debug: true,
          ),
        ),
        const ControllerWidget(),
        const ItemBar(SlotType.itemBar),
        const PlayerInventoryWidget(),
      ],
    );
  }
}
