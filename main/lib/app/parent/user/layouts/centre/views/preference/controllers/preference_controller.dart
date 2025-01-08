import 'package:flutter/cupertino.dart';
import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferenceController extends GetxController {
  PreferenceController();
  final state = PreferenceState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    state.genderSelection.value = Database.setting.gender;
    _getAppSetting();

    super.onInit();
  }

  void _getAppSetting() async {
    var response = await _connect.get(endpoint: "/account/settings");

    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.genderSelection.value = setting.gender;
    }
  }

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
    ParentController.data.state.theme.value = theme;
  }

  List<ButtonView> communications = [
    ButtonView(
      header: "Personal Information Sharing",
      body: "Control if you want Serch to warn you whenever you want to share any personal detail while chatting",
      icon: Icons.account_box_rounded,
      index: 0,
    ),
  ];

  void onCommunicationChanged(bool value) {
    state.preference.value = state.preference.value.copyWith(warnMeOnPersonalInformationSharing: value);

    Database.savePreference(state.preference.value);
  }

  String get active => Database.isUserActive
      ? "User (${Database.preference.active.substring(0, 8)})"
      : "Guest (${Database.preference.active.substring(0, 8)})";

  List<ButtonView> personal() => [
    ButtonView(
      header: "Location Check",
      body: "Skip location check anytime you want to use the platform",
      icon: Icons.add_location_alt_rounded,
      index: 0,
    ),
    ButtonView(
      header: "Default account",
      body: state.preference.value.useLastLoggedInAccountAsDefault
          ? "Current account: $active"
          : "Use my last logged in account as default for next login",
      icon: Icons.manage_accounts_rounded,
      index: 1,
    ),
  ];

  bool personalValue(int index) => index == 0
      ? state.preference.value.skipLocationCheck
      : state.preference.value.useLastLoggedInAccountAsDefault;

  void onPersonalChanged(ButtonView view, bool value) {
    if(view.index == 0) {
      state.preference.value = state.preference.value.copyWith(skipLocationCheck: value);
    } else {
      state.preference.value = state.preference.value.copyWith(useLastLoggedInAccountAsDefault: value);
    }

    Database.savePreference(state.preference.value);
  }

  List<ButtonView> trips() => [
    ButtonView(
      header: "Auto Connection",
      body: "Select if you want Serch to match you with a provider automatically for every request",
      icon: Icons.account_box_rounded,
      index: 0,
    ),
    // ButtonView(
    //   header: "Gender Selection",
    //   body: "Filter what gender you prefer for service trips",
    //   icon: Icons.chat_rounded,
    //   index: 1,
    //   path: state.genderSelection.value.value
    // ),
    ButtonView(
      header: "Certified Providers",
      body: "Show only certified providers on my search",
      icon: CupertinoIcons.doc_append,
      index: 2,
    ),
    ButtonView(
      header: "Verified Providers",
      body: "Show only verified providers on my search",
      icon: CupertinoIcons.checkmark_shield_fill,
      index: 3,
    ),
  ];

  bool showValue(int index) => index == 2 ? state.settings.value.showOnlyCertified : state.settings.value.showOnlyVerified;

  void onAutoChanged(bool value) {
    state.preference.value = state.preference.value.copyWith(autoConnectMeWithProvider: value);

    Database.savePreference(state.preference.value);
  }

  void onGenderChanged(Gender gender, ThemeType theme, PreferenceOption preference, ScheduleTime schedule, SecurityType security) {
    state.genderSelection.value = gender;
    Database.saveAppSetting(Database.setting.copyWith(gender: gender));
  }

  void onShowChanged(ButtonView view, bool value) {
    if(view.index == 2) {
      _updateShowOnlyCertified(value);
    } else {
      _updateShowOnlyVerified(value);
    }
  }

  void _updateShowOnlyCertified(bool value) async {
    state.settings.value = state.settings.value.copyWith(showOnlyCertified: value);
    var response = await _connect.patch(endpoint: "/account/settings/update", body: {
      "show_only_certified": value
    });

    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.settings.value = setting;
    }
  }

  void _updateShowOnlyVerified(bool value) async {
    state.settings.value = state.settings.value.copyWith(showOnlyVerified: value);
    var response = await _connect.patch(endpoint: "/account/settings/update", body: {
      "show_only_verified": value
    });

    if(response.isOk) {
      AppSetting setting = AppSetting.fromJson(response.data);
      Database.saveAppSetting(setting);
      state.settings.value = setting;
    }
  }

  List<ButtonView> notifications() => [
    ButtonView(
      header: "Chat Notification",
      body: "Select how you want to receive chat messages",
      icon: Icons.chat_rounded,
      index: 0,
      path: state.preference.value.chatNotification.type
    ),
    ButtonView(
      header: "Call Notification",
      body: "Control where you receive call notifications",
      icon: Icons.call_rounded,
      index: 1,
      path: state.preference.value.callNotification.type
    ),
    ButtonView(
      header: "Connect Notification",
      body: "Control how you receive connect notifications",
      icon: Icons.connect_without_contact_rounded,
      index: 2,
      path: state.preference.value.connectNotification.type
    ),
    ButtonView(
      header: "Schedule Notification",
      body: "Control where you receive schedule notifications",
      icon: Icons.schedule_rounded,
      index: 3,
      path: state.preference.value.scheduleNotification.type
    ),
    ButtonView(
      header: "Other Notifications",
      body: "Control how you receive other platform notifications",
      icon: Icons.notifications_rounded,
      index: 4,
      path: state.preference.value.otherNotification.type
    ),
    ButtonView(
      header: "Schedule Time",
      body: "Select how early your schedule notifications should come",
      icon: Icons.schedule_rounded,
      index: 5,
      path: state.preference.value.scheduleTime.type
    ),
  ];

  PreferenceOption preferenceValue(int index) => index == 0
      ? state.preference.value.chatNotification
      : index == 1
      ? state.preference.value.callNotification
      : index == 2
      ? state.preference.value.connectNotification
      : index == 3
      ? state.preference.value.scheduleNotification
      : state.preference.value.otherNotification;

  void onNotificationChanged(Gender gender, ThemeType theme, PreferenceOption preference, ScheduleTime schedule, SecurityType security, ButtonView notification) {
    if(notification.index == 0) {
      state.preference.value = state.preference.value.copyWith(chatNotification: preference);
    } else if(notification.index == 1) {
      state.preference.value = state.preference.value.copyWith(callNotification: preference);
    } else if(notification.index == 2) {
      state.preference.value = state.preference.value.copyWith(connectNotification: preference);
    } else if(notification.index == 3) {
      state.preference.value = state.preference.value.copyWith(scheduleNotification: preference);
    } else if(notification.index == 4) {
      state.preference.value = state.preference.value.copyWith(otherNotification: preference);
    } else {
      state.preference.value = state.preference.value.copyWith(scheduleTime: schedule);
    }

    Database.savePreference(state.preference.value);
  }
}