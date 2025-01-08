import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestPrivacyAndSecurityLayout extends GetResponsiveView<GuestPrivacyAndSecurityController> {
  static const String route = "/guest/centre/privacy-and-security";
  GuestPrivacyAndSecurityLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Privacy and Security",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...controller.tabs.map((tab) => CentreNavigator(
              tab: tab,
              onTap: () {
                if(tab.path.isNotEmpty) {
                  Navigate.to(tab.path);
                }
              },
            )),
            const SizedBox(height: 15),
            Container(
              margin: EdgeInsets.all(Sizing.space(16)),
              padding: EdgeInsets.all(Sizing.space(8)),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(24)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: "Device Permissions",
                          color: Theme.of(context).primaryColor,
                          size: Sizing.font(16),
                          weight: FontWeight.bold
                        ),
                        SText(
                          text: "Change permission value from your device settings",
                          color: Theme.of(context).primaryColorLight,
                          size: Sizing.font(12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...controller.permissions.map((tab) => Obx(() => PermissionSwitcher(
                    view: tab,
                    value: controller.getPermissionValue(tab),
                  )))
                ],
              ),
            )
          ],
        )
      )
    );
  }
}