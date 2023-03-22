import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';

class SkyComponent extends ParallaxComponent {
  SkyComponent();

  ComponentMotionState _state = ComponentMotionState.idle;

  void setMotionState(ComponentMotionState state) {
    _state = state;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parallax = await morning;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_state == ComponentMotionState.walkingLeft) {
      parallax?.baseVelocity = Vector2(-2, 0);
    } else if (_state == ComponentMotionState.walkingRight) {
      parallax?.baseVelocity = Vector2(2, 0);
    } else {
      parallax?.baseVelocity = Vector2.zero();
    }
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
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(3, 0),
    );
    return component.parallax;
  }
}
