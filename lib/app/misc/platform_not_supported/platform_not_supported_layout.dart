import 'package:flutter/material.dart';
import 'package:user/library.dart';

class PlatformNotSupportedLayout extends StatelessWidget {
  static String route = "/page/error/platform";

  const PlatformNotSupportedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Padding(
        padding: EdgeInsets.all(Sizing.space(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Media.logo,
              width: 100,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: LineHeader(
                header: "Platform not supported",
                footer: "Serch does not support this platform at the moment",
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Image.asset(
                  Media.tagline,
                  width: 150,
                  color: Theme.of(context).primaryColor
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}