import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:minecraft/global/global_game_reference.dart';

class SkyComponent extends ParallaxComponent {
  SkyComponent();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parallax = await morning;
  }

  Future<Parallax?> get morning => getParallax('morning');
  Future<Parallax?> get evening => getParallax('evening');
  Future<Parallax?> get night => getParallax('night');

  Future<Parallax?> getParallax(String time) async {
    final component =
        await GlobalGameReference.instance.game.loadParallaxComponent(
      [
        ParallaxImageData('parallax/$time/sky.png'),
        ParallaxImageData('parallax/$time/second_parallax.png'),
        ParallaxImageData('parallax/$time/first_parallax.png'),
      ],
      baseVelocity: Vector2(1, 0),
      velocityMultiplierDelta: Vector2(3, 0),
    );
    return component.parallax;
  }
}
