import 'package:user/library.dart';

/// Class representing user preferences.
///
/// This is a class called Preference that seems to represent a user's preferences for notifications, biometric authentication, theme, and scheduling.
///
/// It has the following fields:
///
/// - chatNotify: a boolean value indicating whether the user wants to receive notifications for chat messages.
///
/// - callNotify: a boolean value indicating whether the user wants to receive notifications for calls.
///
/// - otherNotify: a boolean value indicating whether the user wants to receive notifications for other events not covered by chat or call notifications.
///
/// - hasBiometrics: a boolean value indicating whether the user has biometric authentication set up.
///
/// - theme: a ThemeType value indicating the user's preferred theme.
///
/// - timeType: a ScheduleTime value indicating the user's preferred scheduling time format.
class Preference {
  /// Whether "Always Connect Me" is enabled.
  final bool alwaysConnectMe;

  /// PHONE Chat notification preference.
  final bool chatNotify;

  /// PHONE Call notification preference.
  final bool callNotify;

  /// PHONE Other notification preference.
  final bool otherNotify;

  /// PHONE Request preference.
  final bool requestNotify;

  /// PHONE Schedule preference.
  final bool scheduleNotify;

  /// INAPP Chat notification preference.
  final bool chatNotifyInApp;

  /// INAPP Call notification preference.
  final bool callNotifyInApp;

  /// INAPP Other notification preference.
  final bool otherNotifyInApp;

  /// INAPP Request preference.
  final bool requestNotifyInApp;

  /// INAPP Schedule preference.
  final bool scheduleNotifyInApp;

  /// Biometrics preference.
  final bool hasBiometrics;

  /// HasVerifyAuth preference.
  final bool hasVerifyAuth;

  /// bool mode
  final bool needTripAuth;

  /// Theme preference.
  final ThemeType theme;

  /// Schedule time type preference.
  final ScheduleTime timeType;

  /// This is the boolean vaue that tells if the welcome notification has run in the user's device.
  final bool isWelcome;

  /// Warn me when I want to share personal details in chat
  final bool shouldWarnMe;

  /// Wider/Not Wide app bar
  final bool isAppBarWide;

  /// Authentication type to use for device
  final SecurityType security;

  /// Set true to stop popping up the request country bottom sheet
  final bool hasRequestedCountry;

  /// Creates a new instance of Preference with the given properties.
  const Preference({
    this.chatNotify = true,
    this.callNotify = true,
    this.requestNotify = true,
    this.scheduleNotify = true,
    this.hasBiometrics = false,
    this.otherNotify = true,
    this.isWelcome = false,
    this.alwaysConnectMe = false,
    this.timeType = ScheduleTime.thirtyMinutes,
    this.theme = ThemeType.light,
    this.hasVerifyAuth = false,
    this.needTripAuth = false,
    this.shouldWarnMe = true,
    this.isAppBarWide = true,
    this.chatNotifyInApp = true,
    this.callNotifyInApp = true,
    this.requestNotifyInApp = true,
    this.scheduleNotifyInApp = true,
    this.otherNotifyInApp = true,
    this.security = SecurityType.none,
    this.hasRequestedCountry = false
  });

  bool get is30Secs => timeType == ScheduleTime.thirtyMinutes;
  bool get is10Secs => timeType == ScheduleTime.tenMinutes;
  bool get is20Secs => timeType == ScheduleTime.twentyMinutes;

  bool get isDarkTheme => theme == ThemeType.dark;
  bool get isLightTheme => theme == ThemeType.light;

  String get chatSelection => chatNotify && !chatNotifyInApp
    ? PreferenceOption.phone.type
    : !chatNotify && chatNotifyInApp
    ? PreferenceOption.inApp.type
    : !chatNotify && !chatNotifyInApp
    ? PreferenceOption.none.type
    : PreferenceOption.all.type;

  String get callSelection => callNotify && !callNotifyInApp
    ? PreferenceOption.phone.type
    : !callNotify && callNotifyInApp
    ? PreferenceOption.inApp.type
    : !callNotify && !callNotifyInApp
    ? PreferenceOption.none.type
    : PreferenceOption.all.type;

  String get otherSelection => otherNotify && !otherNotifyInApp
    ? PreferenceOption.phone.type
    : !otherNotify && otherNotifyInApp
    ? PreferenceOption.inApp.type
    : !otherNotify && !otherNotifyInApp
    ? PreferenceOption.none.type
    : PreferenceOption.all.type;

  String get requestSelection => requestNotify && !requestNotifyInApp
    ? PreferenceOption.phone.type
    : !requestNotify && requestNotifyInApp
    ? PreferenceOption.inApp.type
    : !requestNotify && !requestNotifyInApp
    ? PreferenceOption.none.type
    : PreferenceOption.all.type;

  String get scheduleSelection => scheduleNotify && !scheduleNotifyInApp
    ? PreferenceOption.phone.type
    : !scheduleNotify && scheduleNotifyInApp
    ? PreferenceOption.inApp.type
    : !scheduleNotify && !scheduleNotifyInApp
    ? PreferenceOption.none.type
    : PreferenceOption.all.type;

  /// Creates a copy of the Preference with optional properties updated.
  Preference copyWith({
    bool? chatNotify,
    bool? callNotify,
    bool? otherNotify,
    bool? requestNotify,
    bool? scheduleNotify,
    bool? chatNotifyInApp,
    bool? callNotifyInApp,
    bool? otherNotifyInApp,
    bool? requestNotifyInApp,
    bool? scheduleNotifyInApp,
    bool? hasBiometrics,
    bool? hasVerifyAuth,
    ThemeType? theme,
    bool? needTripAuth,
    bool? swm,
    bool? isWelcome,
    bool? alwaysConnectMe,
    bool? shouldWarnMe,
    bool? isAppBarWide,
    ScheduleTime? timeType,
    SecurityType? security,
    bool? hasRequestedCountry
  }) {
    return Preference(
      chatNotify: chatNotify ?? this.chatNotify,
      callNotify: callNotify ?? this.callNotify,
      otherNotify: otherNotify ?? this.otherNotify,
      requestNotify: requestNotify ?? this.requestNotify,
      scheduleNotify: scheduleNotify ?? this.scheduleNotify,
      chatNotifyInApp: chatNotifyInApp ?? this.chatNotifyInApp,
      callNotifyInApp: callNotifyInApp ?? this.callNotifyInApp,
      otherNotifyInApp: otherNotifyInApp ?? this.otherNotifyInApp,
      requestNotifyInApp: requestNotifyInApp ?? this.requestNotifyInApp,
      scheduleNotifyInApp: scheduleNotifyInApp ?? this.scheduleNotifyInApp,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      theme: theme ?? this.theme,
      alwaysConnectMe: alwaysConnectMe ?? this.alwaysConnectMe,
      timeType: timeType ?? this.timeType,
      isWelcome: isWelcome ?? this.isWelcome,
      hasVerifyAuth: hasVerifyAuth ?? this.hasVerifyAuth,
      needTripAuth: needTripAuth ?? this.needTripAuth,
      shouldWarnMe: shouldWarnMe ?? this.shouldWarnMe,
      isAppBarWide: isAppBarWide ?? this.isAppBarWide,
      security: security ?? this.security,
      hasRequestedCountry: hasRequestedCountry ?? this.hasRequestedCountry
    );
  }

  Preference.fromJson(Map<String, dynamic> map) :
    chatNotify = map["chat_notify"],
    alwaysConnectMe = map["always_connect_me"],
    callNotify = map["call_notify"],
    otherNotify = map["other_notify"],
    requestNotify = map["request_notify"],
    scheduleNotify = map["schedule_notify"],
    hasBiometrics = map["has_biometrics"],
    hasVerifyAuth = map["has_verify_auth"],
    isWelcome = map["is_welcome"],
    shouldWarnMe = map["should_warn_me"],
    isAppBarWide = map["is_app_bar_wide"],
    needTripAuth = map["need_trip_auth"],
    timeType = (map["time_type"] as String).toScheduleTime(),
    theme = (map["theme"] as String).toThemeType(),
    chatNotifyInApp = map["chat_notify_in_app"],
    callNotifyInApp = map["call_notify_in_app"],
    otherNotifyInApp = map["other_notify_in_app"],
    requestNotifyInApp = map["request_notify_in_app"],
    scheduleNotifyInApp = map["schedule_notify_in_app"],
    security = (map["security"] as String).toSecurityType(),
    hasRequestedCountry = map["has_requested_country"];

  Map<String, dynamic> toJson() => {
    "chat_notify": chatNotify,
    "call_notify": callNotify,
    "other_notify": otherNotify,
    "request_notify": requestNotify,
    "schedule_notify": scheduleNotify,
    "chat_notify_in_app": chatNotifyInApp,
    "call_notify_in_app": callNotifyInApp,
    "other_notify_in_app": otherNotifyInApp,
    "request_notify_in_app": requestNotifyInApp,
    "schedule_notify_in_app": scheduleNotifyInApp,
    "has_biometrics": hasBiometrics,
    "always_connect_me": alwaysConnectMe,
    "should_warn_me": shouldWarnMe,
    "is_app_bar_wide": isAppBarWide,
    "has_verify_auth": hasVerifyAuth,
    "is_welcome": isWelcome,
    "time_type": timeType.type,
    "theme": theme.type,
    "need_trip_auth": needTripAuth,
    "security": security.type,
    "has_requested_country": hasRequestedCountry
  };
}