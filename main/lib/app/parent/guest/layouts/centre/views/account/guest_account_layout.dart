import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestAccountLayout extends GetResponsiveView<GuestAccountController> {
  static const String route = "/guest/centre/account";
  GuestAccountLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Account",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
        actions: [
          InfoButton(onPressed: GuestAccountNotifier.open)
        ],
      ),
      child: Obx(() {
        String avatar = GuestParentController.data.state.guest.value.avatar;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Center(
                  child: Avatar(radius: 90, avatar: avatar),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SText(
                  text: "Profile",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              ...controller.profile().map((profile) => CentreNavigator(tab: profile)),
              const SizedBox(height: 5),
              Divider(color: Theme.of(context).primaryColor),
              if(controller.buttons.isNotEmpty) ...[
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SText(
                    text: "Utilities",
                    color: Theme.of(context).primaryColor,
                    size: Sizing.font(16),
                    weight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                ...controller.buttons.map((button) => CentreNavigator(
                  tab: button,
                  onTap: () => Navigate.to(button.path),
                )),
              ],
              const SizedBox(height: 15),
              ...controller.securities.map((security) => CentreNavigator(
                tab: security,
                onTap: () => GuestHomeController.data.openAccounts,
              ))
            ]
          )
        );
      }),
    );
  }
}