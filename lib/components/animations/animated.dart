import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class Animated extends StatelessWidget {
  const Animated({
    super.key,
    required this.toWidget,
    this.toRoute,
    required this.child,
    this.color,
    this.transition,
    this.borderRadius,
    this.elevation = 4.0,
    this.openElevation = 4.0
  });

  final Widget toWidget;
  final ContainerTransitionType? transition;
  final RouteSettings? toRoute;
  final Widget child;
  final Color? color;
  final double elevation;
  final double openElevation;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transition ?? ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return toWidget;
      },
      routeSettings: toRoute,
      closedElevation: elevation,
      openElevation: openElevation,
      closedShape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(24)
      ),
      closedColor: color ?? Theme.of(context).colorScheme.background,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return child;
      },
    );
  }
}