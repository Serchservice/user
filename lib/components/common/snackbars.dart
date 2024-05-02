import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SnackBars {
  static void top({
    required String message,
    required Snackbar type,
    int duration = 5,
  }) async {
    Get.closeCurrentSnackbar();
    Get.snackbar(
      SnackbarUtility.title(type),
      message,
      duration: Duration(seconds: duration),
      snackStyle: SnackStyle.FLOATING,
      colorText: lightBackgroundColor,
      backgroundColor: SnackbarUtility.color(type),
    );
  }

  /// Displays a basic snackbar
  static void bottom({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    int? timeToLive,
    bool isError = false
  }) {
    /// TODO:: Fix issue with bottom snackbar
    // messenger.currentState?.showSnackBar(
    //   SnackBar(
    //     content: SText(
    //       text: message,
    //       color: textColor ?? Get.theme.primaryColor
    //     ),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //     margin: const EdgeInsets.all(10),
    //     duration: Duration(seconds: timeToLive ?? 2),
    //     backgroundColor: isError
    //       ? CommonColors.error
    //       : backgroundColor ?? Get.theme.scaffoldBackgroundColor,
    //     behavior: SnackBarBehavior.floating,
    //     showCloseIcon: true,
    //     closeIconColor: textColor ?? Get.theme.primaryColor,
    //   )
    // );
  }

  static Future<T?>? showTopModalSheet<T>(
    Widget widget, {
      bool barrierDismissible = true,
      double? topSpace,
      double? leftSpace,
      double? rightSpace,
      double? bottomSpace
    }
  ) {
    if(Get.context != null) {
        return showGeneralDialog<T?>(
        context: Get.context!,
        barrierDismissible: barrierDismissible,
        transitionDuration: const Duration(milliseconds: 250),
        barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, _, __) => SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: topSpace ?? 16,
              left: leftSpace ?? 0,
              right: rightSpace ?? 0,
              bottom: bottomSpace ?? 0
            ),
            child: Column(
              children: [
                SizedBox(height: topSpace ?? 16),
                widget,
              ]
            ),
          )
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic
            ).drive(
              Tween<Offset>(
                begin: const Offset(0, -1.0),
                end: Offset.zero
              )
            ),
            child: child,
          );
        },
      );
    } else {
      return null;
    }
  }
}