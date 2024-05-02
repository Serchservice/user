import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

const ResponsiveScreenSettings screenSettings = ResponsiveScreenSettings(
  desktopChangePoint: 800,
  tabletChangePoint: 700,
  watchChangePoint: 600
);

class ViewLayout extends StatelessWidget {
  const ViewLayout({
    super.key,
    required this.child,
    this.floatingButton,
    this.appbar,
    this.bottomNavbar,
    this.bottomSheet,
    this.floater,
    this.floaterPosition = 230.0,
    this.needSafeArea = true,
    this.backgroundColor,
    this.floatingLocation,
    this.extendBody = false,
    this.extendBehindAppbar = false,
    this.goDark = false,
    this.shouldWillPop = false,
    this.onWillPop,
    this.theme
  });

  final Widget child;
  final Widget? floatingButton;
  final PreferredSizeWidget? appbar;
  final Widget? bottomNavbar;
  final Widget? bottomSheet;
  final Widget? floater;
  final double floaterPosition;
  final Color? backgroundColor;
  final bool needSafeArea;
  final FloatingActionButtonLocation? floatingLocation;
  final bool extendBody;
  final bool extendBehindAppbar;
  final bool goDark;
  final bool shouldWillPop;
  final ThemeType? theme;
  final Function(bool)? onWillPop;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: goDark
          ? darkBackgroundColor
          : Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor,
        systemNavigationBarColor: goDark
          ? darkBackgroundColor
          : Theme.of(context).appBarTheme.systemOverlayStyle?.systemNavigationBarColor,
        statusBarIconBrightness: goDark
          ? Brightness.light
          : (theme != null && theme == ThemeType.light) || Database.preference.isLightTheme
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarIconBrightness: goDark
          ? Brightness.light
          : (theme != null && theme == ThemeType.light) || Database.preference.isLightTheme
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        appBar: appbar,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBehindAppbar,
        backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        body: _buildBody(context),
        floatingActionButton: floatingButton,
        floatingActionButtonLocation: floatingLocation,
        bottomNavigationBar: bottomNavbar,
        bottomSheet: bottomSheet,
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    if(shouldWillPop && needSafeArea && floater != null) {
      return PopScope(
        onPopInvoked: onWillPop,
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: child
              ),
              Positioned(
                bottom: floaterPosition,
                child: SizedBox(
                  width: Get.width,
                  child: floater!
                )
              )
            ],
          )
        )
      );
    }

    if(shouldWillPop && needSafeArea) {
      return PopScope(onPopInvoked: onWillPop, child: SafeArea(child: child));
    }

    if(shouldWillPop) {
      return PopScope(onPopInvoked: onWillPop, child: child);
    }

    if(floater != null && needSafeArea) {
      return SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: child
            ),
            Positioned(
              bottom: floaterPosition,
              child: SizedBox(
                width: Get.width,
                child: floater!
              )
            )
          ],
        )
      );
    }

    if(floater != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: child
          ),
          Positioned(
            bottom: floaterPosition,
            child: SizedBox(
              width: Get.width,
              child: floater!
            )
          )
        ],
      );
    }

    if(needSafeArea) {
      return SafeArea(child: child);
    }

    return child;
  }
}