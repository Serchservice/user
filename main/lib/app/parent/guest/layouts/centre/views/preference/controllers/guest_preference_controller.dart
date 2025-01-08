import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestPreferenceController extends GetxController {
  GuestPreferenceController();
  final state = GuestPreferenceState();

  ButtonView theme() => ButtonView(
    header: "Theme",
    body: "Change your app display mode",
    icon: Icons.color_lens_rounded,
    index: 0,
    path: state.preference.value.theme.type
  );

  void onThemeChanged(Gender gender, ThemeType theme, PreferenceOption preference, ScheduleTime schedule, SecurityType security) {
    if(theme == ThemeType.light) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    state.preference.value = state.preference.value.copyWith(theme: theme);
    Database.savePreference(state.preference.value);
    GuestParentController.data.state.theme.value = theme;
  }

  List<ButtonView> personal() => [
    ButtonView(
      header: "Location Check",
      body: "Skip location check anytime you want to use the platform",
      icon: Icons.add_location_alt_rounded,
      index: 0,
    ),
    ButtonView(
      header: "Default account",
      body: state.guestPreference.value.useLastLoggedInAccountAsDefault
          ? "Current account: ${"Guest (${Database.preference.active.substring(0, 8)})"}"
          : "Use my last logged in account as default for next login",
      icon: Icons.manage_accounts_rounded,
      index: 1,
    ),
  ];

  bool personalValue(int index) => index == 0
      ? state.guestPreference.value.skipLocationCheck
      : state.guestPreference.value.useLastLoggedInAccountAsDefault;

  void onPersonalChanged(ButtonView view, bool value) {
    if(view.index == 0) {
      state.guestPreference.value = state.guestPreference.value.copyWith(skipLocationCheck: value);
    } else {
      state.guestPreference.value = state.guestPreference.value.copyWith(useLastLoggedInAccountAsDefault: value);
    }

    Database.saveGuestPreference(state.guestPreference.value);
  }

  List<ButtonView> notifications() => [
    ButtonView(
      header: "Connect Notification",
      body: "Control how you receive connect notifications",
      icon: Icons.connect_without_contact_rounded,
      index: 1,
      path: state.guestPreference.value.connectNotification.type
    ),
    ButtonView(
      header: "Other Notifications",
      body: "Control how you receive other platform notifications",
      icon: Icons.notifications_rounded,
      index: 2,
      path: state.guestPreference.value.otherNotification.type
    ),
  ];

  PreferenceOption preferenceValue(int index) => index == 0
      ? state.guestPreference.value.connectNotification
      : state.guestPreference.value.otherNotification;

  void onNotificationChanged(Gender gender, ThemeType theme, PreferenceOption preference, ScheduleTime schedule, SecurityType security, ButtonView notification) {
    if(notification.index == 0) {
      state.guestPreference.value = state.guestPreference.value.copyWith(connectNotification: preference);
    } else {
      state.guestPreference.value = state.guestPreference.value.copyWith(otherNotification: preference);
    }

    Database.saveGuestPreference(state.guestPreference.value);
  }
}