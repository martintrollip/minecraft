import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/controller_button_widget.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 100,
      left: 20,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            ControllerButtonWidget(
                path: 'assets/controller/left_button.png',
                onTap: () => GameMethods.instance.leftAction()),
            ControllerButtonWidget(
                path: 'assets/controller/center_button.png',
                onTap: () => GameMethods.instance.jumpAction()),
            ControllerButtonWidget(
                path: 'assets/controller/right_button.png',
                onTap: () => GameMethods.instance.rightAction()),
          ],
        ),
      ),
    );
  }
}
