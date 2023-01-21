import 'package:get/instance_manager.dart';
import 'package:minecraft/main_game.dart';

class GlobalGameReference {
  late MainGame game;

  static GlobalGameReference get instance {
    return Get.put(GlobalGameReference());
  }
}
