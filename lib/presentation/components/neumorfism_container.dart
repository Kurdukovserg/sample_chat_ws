import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NeumorfismContainer extends StatelessWidget {
  const NeumorfismContainer({
    super.key,
    required this.radius,
    required this.child,
    this.isInset = false,
    this.blurRadius = 22,
    this.distance = 12,
    this.constraints,
    this.tint,
  });

  final double radius;
  final double blurRadius;
  final Widget child;
  final bool isInset;
  final double distance;
  final BoxConstraints? constraints;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    final effectiveDistance = isInset ? distance / 2 : distance;
    final effectiveBlurRadius = isInset ? blurRadius / 2.5 : blurRadius;
    final offset = Offset(effectiveDistance, effectiveDistance);
    return AnimatedContainer(
      constraints: constraints,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
          color: tint ?? Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: effectiveBlurRadius,
              offset: -offset,
              color: color.withOpacity(0.2),
              inset: isInset,
            ),
            BoxShadow(
                blurRadius: effectiveBlurRadius,
                offset: offset,
                color: Theme.of(context).colorScheme.surfaceDim,
                inset: isInset)
          ]),
      duration: kThemeAnimationDuration,
      child: child,
    );
  }
}
