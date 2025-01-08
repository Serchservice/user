import 'package:user/library.dart';
import 'package:flutter/material.dart';

class BiometricsAuthIcon extends StatelessWidget {
  final BiometricAuthState state;

  const BiometricsAuthIcon({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    double iconSize = 60;
    if(state == BiometricAuthState.none) {
      return Icon(
        Icons.fingerprint_rounded,
        color: getColor(state, context),
        size: iconSize
      );
    } else if(state == BiometricAuthState.failed) {
      return Icon(
        Icons.error_rounded,
        color: getColor(state, context),
        size: iconSize
      );
    } else {
      return Icon(
        Icons.check_circle_rounded,
        color: getColor(state, context),
        size: iconSize
      );
    }
  }

  static Color getColor(BiometricAuthState state, BuildContext context) {
    switch(state) {
      case BiometricAuthState.none:
        return Theme.of(context).primaryColorLight;
      case BiometricAuthState.failed:
        return CommonColors.error;
      default:
        return CommonColors.green;
    }
  }
}