import 'package:chat_sample_app/presentation/components/neumorfism_container.dart';
import 'package:flutter/material.dart';

class NeumorfismButton extends StatefulWidget {
  const NeumorfismButton({
    super.key,
    required this.child,
    required this.onPress,
    required this.radius,
  });

  final Widget child;
  final VoidCallback onPress;
  final double radius;

  @override
  State<NeumorfismButton> createState() => _NeumorfismButtonState();
}

class _NeumorfismButtonState extends State<NeumorfismButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_){
        setState(() {
          isPressed = false;
        });
      },
      onPointerDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      child: GestureDetector(
        onTap: widget.onPress,

        child: NeumorfismContainer(
          radius: widget.radius,
          isInset: isPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
