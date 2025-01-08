import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestPreferenceLayout extends GetResponsiveView<GuestPreferenceController> {
  static const String route = "/guest/centre/preference";
  GuestPreferenceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Preference",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Obx(() {
        ThemeType theme = controller.state.preference.value.theme;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreferenceNavigator(
                view: controller.theme(),
                onTap: () => PreferenceSelector.open(
                  header: "Theme Settings",
                  isTheme: true,
                  selectedTheme: theme,
                  onChanged: controller.onThemeChanged
                )
              ),
              const SizedBox(height: 15),
              if(controller.personal().isNotEmpty) ...[
                _buildHeader(context, "Personalization"),
                ...controller.personal().map((personalization) => PreferenceSwitcher(
                  view: personalization,
                  onChange: (value) => controller.onPersonalChanged(personalization, value),
                  value: controller.personalValue(personalization.index),
                )),
                const SizedBox(height: 15),
              ],
              if(controller.notifications().isNotEmpty) ...[
                _buildHeader(context, "Notification"),
                ...controller.notifications().map((notification) => PreferenceNavigator(
                  view: notification,
                  onTap: () => PreferenceSelector.open(
                    header: notification.header,
                    isScheduleTime: notification.index == 5,
                    selectedSchedule: controller.state.preference.value.scheduleTime,
                    selectedPreference: controller.preferenceValue(notification.index),
                    onChanged: (gender, theme, preference, schedule, security) {
                      controller.onNotificationChanged(gender, theme, preference, schedule, security, notification);
                    }
                  )
                )),
              ]
            ],
          )
        );
      })
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SText(
            text: title,
            color: Theme.of(context).primaryColor,
            size: Sizing.font(16),
            weight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}