import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferenceLayout extends GetResponsiveView<PreferenceController> {
  static const String route = "/centre/preference";
  PreferenceLayout({super.key});

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
              if(controller.trips().isNotEmpty) ...[
                _buildHeader(context, "Trip"),
                ...controller.trips().map((trip) {
                  if(trip.index == 0) {
                    return PreferenceSwitcher(
                      view: trip,
                      onChange: controller.onAutoChanged,
                      value: controller.state.preference.value.autoConnectMeWithProvider,
                    );
                  } else if(trip.index == 1) {
                    return PreferenceNavigator(
                      view: trip,
                      onTap: () => PreferenceSelector.open(
                        header: trip.header,
                        isGender: true,
                        selectedGender: controller.state.genderSelection.value,
                        onChanged: controller.onGenderChanged
                      )
                    );
                  } else {
                    return PreferenceSwitcher(
                      view: trip,
                      onChange: (value) => controller.onShowChanged(trip, value),
                      value: controller.showValue(trip.index),
                    );
                  }
                }),
                const SizedBox(height: 15),
              ],
              if(controller.personal().isNotEmpty) ...[
                _buildHeader(context, "Personalization"),
                ...controller.personal().map((personalization) => PreferenceSwitcher(
                  view: personalization,
                  onChange: (value) => controller.onPersonalChanged(personalization, value),
                  value: controller.personalValue(personalization.index),
                )),
                const SizedBox(height: 15),
              ],
              if(controller.communications.isNotEmpty) ...[
                _buildHeader(context, "Communication"),
                ...controller.communications.map((communication) => PreferenceSwitcher(
                  view: communication,
                  onTap: () => PersonalInformationSharing.open(
                    isActivated: controller.state.preference.value.warnMeOnPersonalInformationSharing,
                    onClicked: (value) {
                      controller.onCommunicationChanged(value);
                      Navigate.back();
                    },
                  ),
                  onChange: (value) => PersonalInformationSharing.open(
                    isActivated: controller.state.preference.value.warnMeOnPersonalInformationSharing,
                    onClicked: (value) {
                      controller.onCommunicationChanged(value);
                      Navigate.back();
                    },
                  ),
                  value: controller.state.preference.value.warnMeOnPersonalInformationSharing,
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