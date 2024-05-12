import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class HelpLayout extends GetResponsiveView<HelpController> {
  static const String route = "/centre/app/help";
  HelpLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Help Centre",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => CentreNavigator(
                  tab: controller.chatWithSerch,
                  needNotification: controller.homeController.state.hasSerchMessage.value,
                  onTap: () => Navigate.to(controller.chatWithSerch.path)
                )),
                ...controller.help.map((tab) {
                  return CentreNavigator(
                    tab: tab,
                    onTap: () {
                      if(tab.index == 0) {
                        RouteNavigator.mail(tab.path);
                      } else if(tab.index == 1) {
                        RouteNavigator.callNumber(tab.path);
                      } else {
                        RouteNavigator.openLink(url: tab.path);
                      }
                    }
                  );
                }),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(Sizing.space(12)),
              child: Column(
                children: [
                  SText.center(
                    text: "Connect with us",
                    size: Sizing.font(11),
                    color: Theme.of(context).primaryColorLight
                  ),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    runSpacing: 5,
                    children: controller.media.map((media) {
                      return IconButton(
                        splashRadius: 16,
                        padding: EdgeInsets.all(Sizing.space(5)),
                        tooltip: media.header,
                        onPressed: () => RouteNavigator.openLink(url: media.path),
                        icon: Icon(
                          media.icon,
                          color: Theme.of(context).primaryColor,
                          size: Sizing.space(16),
                        )
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ]
      )
    );
  }
}