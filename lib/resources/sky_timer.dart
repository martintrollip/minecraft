import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/constant.dart';

enum SkyTime { morning, evening, night }

class SkyTimer extends TimerComponent {
  SkyTimer() : super(period: dayLengthSeconds / 3, repeat: true);

  SkyTime _skyTime = SkyTime.morning;

  @override
  void onTick() {
    final index = SkyTime.values.indexOf(_skyTime);
    _skyTime = SkyTime.values[(index + 1) % SkyTime.values.length];
    GlobalGameReference.instance.game.skyComponent.setTime(_skyTime);
  }
}
