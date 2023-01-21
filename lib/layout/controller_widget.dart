import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/widgets/controller_button_widget.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final playerData = GlobalGameReference.instance.game.worldData.playerData;
    return Positioned.fill(
      bottom: 100,
      left: 20,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            ControllerButtonWidget(
              path: 'assets/controller/left_button.png',
              onTap: () => playerData.componentMotionState =
                  ComponentMotionState.walkingLeft,
            ),
            ControllerButtonWidget(
              path: 'assets/controller/center_button.png',
              onTap: () =>
                  playerData.componentMotionState = ComponentMotionState.idle,
            ),
            ControllerButtonWidget(
              path: 'assets/controller/right_button.png',
              onTap: () => playerData.componentMotionState =
                  ComponentMotionState.walkingRight,
            ),
          ],
        ),
      ),
    );
  }
}
