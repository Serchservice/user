import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PrivacyAndSecurityLayout extends GetResponsiveView<PrivacyAndSecurityController> {
  static const String route = "/centre/privacy-and-security";
  PrivacyAndSecurityLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<ButtonView> tabs = [
        ButtonView(
          header: "Biometrics",
          body: "Protect your account with your fingerprint",
          icon: Icons.fingerprint_rounded,
          index: 0,
          path: BiometricsLayout.route
        ),
        ButtonView(
          header: "Two-Factor Authentication",
          body: "Protect your account with your multi-factor authentication",
          icon: Icons.security_rounded,
          index: 1,
          path: MultiFactorLayout.route
        ),
        ButtonView(
          header: "Password",
          body: "Last Changed: ${controller.state.passwordLastUpdatedAt.value}",
          icon: Icons.password_rounded,
          index: 2,
          path: ChangePasswordLayout.route
        ),
      ];

      List<ButtonView> permissions = [
        ButtonView(
          header: "Location",
          body: "Permission Level: Very important",
          icon: Icons.location_pin,
          index: 0,
        ),
        ButtonView(
          header: "Storage",
          body: "Permission Level: Important",
          icon: Icons.storage_rounded,
          index: 1,
        ),
        ButtonView(
          header: "Notification",
          body: "Permission Level: Important",
          icon: Icons.notifications_active_rounded,
          index: 2,
        ),
        ButtonView(
          header: "Contact",
          body: "Permission Level: Important",
          icon: Icons.contacts_rounded,
          index: 3,
        ),
        ButtonView(
          header: "Microphone/Audio",
          body: "Permission Level: Needed",
          icon: Icons.mic_rounded,
          index: 4,
        ),
        ButtonView(
          header: "Camera",
          body: "Permission Level: Needed",
          icon: Icons.camera_rounded,
          index: 5,
        ),
      ];

      ButtonView securityLogin = ButtonView(
        header: "Login Security",
        body: "Select your preferred extra security layer for login",
        icon: Icons.login_rounded,
        index: 5,
        path: controller.state.preference.value.security.type
      );
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tabs.map((tab) => CentreNavigator(
                  tab: tab,
                  onTap: () {
                    if(tab.path.isNotEmpty) {
                      Navigate.to(tab.path);
                    }
                  },
                )).toList(),
              ),
              if(controller.state.auth.value.hasMfa && controller.state.preference.value.hasBiometrics)...[
                PreferenceNavigator(
                  view: securityLogin,
                  onTap: () => PreferenceSelector.open(
                    header: "Login Security",
                    isSecurity: true,
                    selectedSecurity: controller.state.preference.value.security,
                    onChanged: (gender, theme, preference, schedule, security) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(
                        security: security
                      );
                      Database.savePreference(controller.state.preference.value);
                    }
                  ),
                )
              ],
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
                    ...permissions.map((tab) => Obx(() => PermissionSwitcher(
                      view: tab,
                      value: tab.index == 0
                        ? controller.state.isLocationGranted.value
                        : tab.index == 1
                        ? controller.state.isStorageGranted.value
                        : tab.index == 2
                        ? controller.state.isNotificationGranted.value
                        : tab.index == 3
                        ? controller.state.isContactGranted.value
                        : tab.index == 4
                        ? controller.state.isMicrophoneGranted.value
                        : controller.state.isCameraGranted.value,
                    )))
                  ],
                ),
              )
            ],
          )
        )
      );
    });
  }
}

class PermissionSwitcher extends StatelessWidget {
  const PermissionSwitcher({
    super.key,
    required this.view,
    required this.value,
  });

  final ButtonView view;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            view.icon,
            color: Theme.of(context).primaryColor,
            size: Sizing.space(24)
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: view.header,
                  size: Sizing.font(15),
                  color: Theme.of(context).primaryColor
                ),
                SText(
                  text: view.body,
                  size: Sizing.font(12),
                  color: Theme.of(context).primaryColorLight
                ),
              ],
            )
          ),
          const SizedBox(width: 30),
          Switcher(
            onChanged: (value) {},
            value: value
          )
        ],
      ),
    );
  }
}