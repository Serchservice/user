import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUpdatesLayout extends GetResponsiveView<AppUpdatesController> {
  static const String route = "/centre/app/updates";
  AppUpdatesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Update Log",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: ListView.builder(
        itemCount: controller.updates.length,
        itemBuilder: (context, index) {
          return AppUpdateBox(update: controller.updates[index]);
        }
      )
    );
  }
}

class AppUpdateBox extends StatelessWidget {
  final UpdateLogView update;
  const AppUpdateBox({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Expandable(
        mainColor: Theme.of(context).splashColor,
        header: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SText(
              text: update.date,
              size: Sizing.font(12),
              color: CommonColors.hint
            ),
            const SizedBox(height: 5),
            SText(
              text: update.header,
              size: Sizing.font(16),
              color: Theme.of(context).primaryColor,
              weight: FontWeight.bold
            ),
          ]
        ),
        content: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: update.content.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle_rounded,
                      size: Sizing.font(6),
                      color: CommonColors.hint
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: SText(
                        text: item,
                        color: CommonColors.hint,
                        size: Sizing.font(14)
                      )
                    )
                  ]
                ),
              )).toList()
            ),
          ],
        ),
      ),
    );
  }
}