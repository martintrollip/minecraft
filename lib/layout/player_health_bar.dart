import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';

class PlayerHealthBar extends StatelessWidget {
  const PlayerHealthBar({super.key});

  @override
  Widget build(BuildContext context) {
    final hearts = <Widget>[];
    final health = 5;

    for (int i = 0; i < 10; i++) {
      hearts.add(getHeartWidget(i < health));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: hearts,
      ),
    );
  }

  Widget getHeartWidget(bool full) {
    final width = GameMethods.instance.screenSize().width / 32;
    return SizedBox(
      width: width,
      height: width,
      child: FittedBox(
        child: Stack(
          children: [
            Image.asset('assets/images/gui/empty_heart.png'),
            if (full) Image.asset('assets/images/gui/full_heart.png'),
          ],
        ),
      ),
    );
  }
}
