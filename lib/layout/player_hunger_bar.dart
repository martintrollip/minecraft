import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../global/global_game_reference.dart';

class PlayerHungerBar extends StatelessWidget {
  const PlayerHungerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hungers = <Widget>[];
      final hunger = GlobalGameReference
          .instance.game.worldData.playerData.playerHunger.value;

      for (int i = 0; i < 10; i++) {
        hungers.add(getHungerWidget(i < hunger));
      }

      final height = GameMethods.instance.screenSize().width / 32;
      const padding = 24.0;
      return Positioned(
        top: height + padding / 2,
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            children: hungers,
          ),
        ),
      );
    });
  }

  Widget getHungerWidget(bool full) {
    final width = GameMethods.instance.screenSize().width / 32;
    return SizedBox(
      width: width,
      height: width,
      child: FittedBox(
        child: Stack(
          children: [
            Image.asset('assets/images/gui/empty_hunger.png'),
            if (full) Image.asset('assets/images/gui/full_hunger.png'),
          ],
        ),
      ),
    );
  }
}
