import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SnackbarUtility {
  static Color color(snackbar) {
    switch (snackbar) {
      case Snackbar.error:
        return CommonColors.error;
      case Snackbar.success:
        return CommonColors.green;
      case Snackbar.warning:
        return CommonColors.yellow;
      default:
        return CommonColors.grey;
    }
  }

  static String title(snackbar){
    switch (snackbar) {
      case Snackbar.error:
        return "Error Notification";
      case Snackbar.success:
        return "Success Notification";
      case Snackbar.warning:
        return "Warning Notification";
      default:
        return "For Your Information...";
    }
  }
}