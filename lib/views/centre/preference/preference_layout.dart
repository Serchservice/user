import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PreferenceLayout extends GetResponsiveView<PreferenceController> {
  static const String route = "/centre/preference";
  PreferenceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
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
        ButtonView theme = ButtonView(
          header: "Theme",
          body: "Change your app display mode",
          icon: Icons.color_lens_rounded,
          index: 0,
          path: controller.state.preference.value.theme.type
        );

        List<ButtonView> communications = [
          ButtonView(
            header: "Personal Information Sharing",
            body: "Control if you want Serch to warn you whenever you want to share any personal detail",
            icon: Icons.account_box_rounded,
            index: 0,
          ),
        ];

        List<ButtonView> trips = [
          ButtonView(
            header: "Gender Selection",
            body: "Filter what genders you want for trip",
            icon: Icons.chat_rounded,
            index: 0,
            path: controller.state.genderSelection.value.value
          ),
          ButtonView(
            header: "Auto Connection",
            body: "Select if you want Serch to match you with a provider automatically for every request",
            icon: Icons.account_box_rounded,
            index: 1,
          ),
        ];

        List<ButtonView> notifications = [
          ButtonView(
            header: "Chat Notification",
            body: "Select how you want to receive chat messages",
            icon: Icons.chat_rounded,
            index: 0,
            path: controller.state.preference.value.chatNotification.type
          ),
          ButtonView(
            header: "Call Notification",
            body: "Control where you receive call notifications",
            icon: Icons.call_rounded,
            index: 1,
            path: controller.state.preference.value.callNotification.type
          ),
          ButtonView(
            header: "Connect Notification",
            body: "Control how you recieve connect notifications",
            icon: Icons.connect_without_contact_rounded,
            index: 2,
            path: controller.state.preference.value.connectNotification.type
          ),
          ButtonView(
            header: "Schedule Notification",
            body: "Control where you receive schedule notifications",
            icon: Icons.schedule_rounded,
            index: 3,
            path: controller.state.preference.value.scheduleNotification.type
          ),
          ButtonView(
            header: "Other Notifications",
            body: "Control how you receive other platform notifications",
            icon: Icons.notifications_rounded,
            index: 4,
            path: controller.state.preference.value.otherNotification.type
          ),
          ButtonView(
            header: "Schedule Time",
            body: "Select how early your schedule notifications should come",
            icon: Icons.schedule_rounded,
            index: 5,
            path: controller.state.preference.value.scheduleTime.type
          ),
        ];
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              // Divider(color: Theme.of(context).primaryColor),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SText(
                  text: "Trip",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              ...trips.map((trip) {
                if(trip.index == 0) {
                  return PreferenceNavigator(
                    view: trip,
                    onTap: () => PreferenceSelector.open(
                      header: trip.header,
                      isGender: true,
                      selectedGender: controller.state.genderSelection.value,
                      onChanged: (gender, theme, preference, schedule, security) {
                        controller.state.genderSelection.value = gender;
                        Database.saveAppSetting(Database.setting.copyWith(gender: gender));
                      }
                    )
                  );
                } else {
                  return PreferenceSwitcher(
                    view: trip,
                    onChange: (value) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(
                        autoConnectMeWithProvider: value
                      );
                      Database.savePreference(controller.state.preference.value);
                    },
                    value: controller.state.preference.value.autoConnectMeWithProvider,
                  );
                }
              }),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SText(
                  text: "Communication",
                  color: Theme.of(context).primaryColor,
                  size: Sizing.font(16),
                  weight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              ...communications.map((communication) => PreferenceSwitcher(
                view: communication,
                onChange: (value) {
                  controller.state.preference.value = controller.state.preference.value.copyWith(
                    warnMeOnPersonalInformationSharing: value
                  );
                  Database.savePreference(controller.state.preference.value);
                },
                value: controller.state.preference.value.warnMeOnPersonalInformationSharing,
              )),
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
                  isScheduleTime: notification.index == 5,
                  selectedSchedule: controller.state.preference.value.scheduleTime,
                  selectedPreference: notification.index == 0
                    ? controller.state.preference.value.chatNotification
                    : notification.index == 1
                    ? controller.state.preference.value.callNotification
                    : notification.index == 2
                    ? controller.state.preference.value.connectNotification
                    : notification.index == 3
                    ? controller.state.preference.value.scheduleNotification
                    : controller.state.preference.value.otherNotification,
                  onChanged: (gender, theme, preference, schedule, security) {
                    if(notification.index == 0) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(chatNotification: preference);
                    } else if(notification.index == 1) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(callNotification: preference);
                    } else if(notification.index == 2) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(connectNotification: preference);
                    } else if(notification.index == 3) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(scheduleNotification: preference);
                    } else if(notification.index == 4) {
                      controller.state.preference.value = controller.state.preference.value.copyWith(otherNotification: preference);
                    } else {
                      controller.state.preference.value = controller.state.preference.value.copyWith(scheduleTime: schedule);
                    }
                    Database.savePreference(controller.state.preference.value);
                  }
                )
              )),
            ],
          )
        );
      })
    );
  }
}

class PreferenceSwitcher extends StatelessWidget {
  const PreferenceSwitcher({
    super.key,
    required this.view,
    required this.onChange,
    required this.value,
  });

  final ButtonView view;
  final Function(bool value) onChange;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(16)),
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
            onChanged: (value) {
              onChange.call(value);
            },
            value: value
          )
        ],
      ),
    );
  }
}

class PreferenceNavigator extends StatelessWidget {
  const PreferenceNavigator({
    super.key,
    required this.view,
    this.onTap
  });

  final ButtonView view;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
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
              SText(
                text: view.path,
                size: Sizing.font(14),
                color: Theme.of(context).primaryColorLight
              ),
            ],
          ),
        )
      )
    );
  }
}