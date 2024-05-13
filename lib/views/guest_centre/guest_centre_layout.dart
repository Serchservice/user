import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestCentreLayout extends GetResponsiveView<GuestHomeController> {
  GuestCentreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Profile",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        ButtonView theme = ButtonView(
          header: "Theme",
          body: "Change your app display mode",
          icon: Icons.color_lens_rounded,
          index: 0,
          path: controller.state.preference.value.theme.type
        );

        List<ButtonView> notifications = [
          ButtonView(
            header: "Connect Notification",
            body: "Control how you recieve connect notifications",
            icon: Icons.connect_without_contact_rounded,
            index: 2,
            path: controller.state.preference.value.connectNotification.type
          ),
          ButtonView(
            header: "Other Notifications",
            body: "Control how you receive other platform notifications",
            icon: Icons.notifications_rounded,
            index: 4,
            path: controller.state.preference.value.otherNotification.type
          ),
        ];

        List<ButtonView> guest = [
          ButtonView(
            icon: Icons.person_outline_rounded,
            header: "Legal FirstName",
            body: controller.state.guest.value.firstName,
          ),
          ButtonView(
            icon: Icons.person_3_outlined,
            header: "Legal LastName",
            body: controller.state.guest.value.lastName,
          ),
          ButtonView(
            icon: Icons.phone_outlined,
            header: "Joined At",
            body: controller.state.guest.value.joinedAt,
          ),
          ButtonView(
            icon: Icons.people_outline_outlined,
            header: "Gender",
            body: controller.state.guest.value.gender,
          ),
          ButtonView(
            icon: Icons.email_outlined,
            header: "Email Address",
            body: controller.state.guest.value.emailAddress,
          ),
        ];
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 20
                ),
                child: Center(
                  child: Avatar(
                    radius: 90,
                    avatar: controller.state.guest.value.avatar,
                  ),
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
              ...guest.map((profile) => CentreNavigator(tab: profile)),
              Divider(color: Theme.of(context).primaryColor),
              PreferenceNavigator(
                view: theme,
                onTap: () => PreferenceSelector.open(
                  header: "Theme Settings",
                  isTheme: true,
                  selectedTheme: controller.state.preference.value.theme,
                  onChanged: (gender, theme, preference, schedule, security) {
                    controller.updateTheme(theme);
                  }
                )
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SText(
                  text: "Notification",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              ...notifications.map((notification) => PreferenceNavigator(
                view: notification,
                onTap: () => PreferenceSelector.open(
                  header: notification.header,
                  selectedPreference: notification.index == 2
                    ? controller.state.preference.value.connectNotification
                    : controller.state.preference.value.otherNotification,
                  onChanged: (gender, theme, preference, schedule, security) {
                    if(notification.index == 2) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(connectNotification: preference);
                    } else {
                      controller.state.preference.value = controller.state.preference.value.copyWith(otherNotification: preference);
                    }
                    Database.savePreference(controller.state.preference.value);
                  }
                )
              )),
              if(!Database.isLoggedIn) ...[
                const SizedBox(height: 20),
                Center(
                  child: LoadingButton(
                    text: "Become a user",
                    borderRadius: 24,
                    width: MediaQuery.of(context).size.width,
                    textSize: Sizing.font(14),
                    buttonColor: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).scaffoldBackgroundColor,
                    onClick: () => controller.confirmEmail(),
                  ),
                )
              ]
            ],
          )
        );
      })
    );
  }
}