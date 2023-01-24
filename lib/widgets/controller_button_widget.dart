import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';

class ControllerButtonWidget extends StatefulWidget {
  const ControllerButtonWidget({
    required this.path,
    required this.onTap,
    super.key,
  });

  final String path;
  final VoidCallback onTap;

  @override
  State<ControllerButtonWidget> createState() => _ControllerButtonWidgetState();
}

class _ControllerButtonWidgetState extends State<ControllerButtonWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
          widget.onTap();
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
            _idle();
          });
        },
        child: Opacity(
          opacity: isPressed ? 0.5 : 0.8,
          child: SizedBox.square(
              dimension: size.width / 17, child: Image.asset(widget.path)),
        ),
      ),
    );
  }

  void _idle() {
    GameMethods.instance.idleAction();
  }
}
