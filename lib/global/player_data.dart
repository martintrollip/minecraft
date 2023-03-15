import 'package:get/get_rx/get_rx.dart';

class PlayerData {
  Rx<double> playerHunger = 10.0.obs;
  Rx<double> playerHealth = 10.0.obs;
  ComponentMotionState componentMotionState = ComponentMotionState.idle;
}

enum ComponentMotionState { walkingLeft, walkingRight, idle, jumping }
