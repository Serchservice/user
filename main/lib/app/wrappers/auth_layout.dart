import 'package:user/library.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool isScrollable;

  const AuthLayout({
    super.key,
    required this.child,
    this.backgroundColor
  }) : isScrollable = false;

  const AuthLayout.scrollable({
    super.key,
    required this.child,
    this.backgroundColor
  }) : isScrollable = true;

  @override
  Widget build(BuildContext context) {
    ResponsiveBreakpoint breakPoint = ResponsiveBreakpoint.init(context);

    if(breakPoint.isDesktop || breakPoint.isTablet) {
      double divider = breakPoint.isDesktop ? 2.5 : 1.6;

      Widget childView = Column(
        children: [
          child,
          SizedBox(height: 30)
        ]
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width / divider,
              child: Card(
                elevation: 2,
                color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: isScrollable ? SingleChildScrollView(child: childView) : childView
              )
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(child: child);
    }
  }
}