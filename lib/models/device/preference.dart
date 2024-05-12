import 'package:user/library.dart';

/// Class representing user preferences.
///
/// This is a class called Preference that seems to represent a user's preferences
///  for notifications, biometric authentication, theme, and scheduling.
class Preference {
  final bool autoConnectMeWithProvider;
  final PreferenceOption chatNotification;
  final PreferenceOption callNotification;
  final PreferenceOption otherNotification;
  final PreferenceOption connectNotification;
  final PreferenceOption scheduleNotification;
  final bool hasBiometrics;
  final ThemeType theme;
  final ScheduleTime scheduleTime;
  final bool warnMeOnPersonalInformationSharing;
  final SecurityType security;
  final bool hasRequestedCountry;
  final bool remember;
  final String active;

  const Preference({
    this.chatNotification = PreferenceOption.none,
    this.callNotification = PreferenceOption.none,
    this.connectNotification = PreferenceOption.none,
    this.scheduleNotification = PreferenceOption.none,
    this.hasBiometrics = false,
    this.otherNotification = PreferenceOption.none,
    this.autoConnectMeWithProvider = false,
    this.scheduleTime = ScheduleTime.thirtyMinutes,
    this.theme = ThemeType.light,
    this.warnMeOnPersonalInformationSharing = true,
    this.security = SecurityType.none,
    this.hasRequestedCountry = false,
    this.remember = false,
    this.active = ""
  });

  bool get is30Secs => scheduleTime == ScheduleTime.thirtyMinutes;
  bool get is10Secs => scheduleTime == ScheduleTime.tenMinutes;
  bool get is20Secs => scheduleTime == ScheduleTime.twentyMinutes;

  bool get isDarkTheme => theme == ThemeType.dark;
  bool get isLightTheme => theme == ThemeType.light;

  bool get isMFA => security == SecurityType.mfa;
  bool get isBiometrics => security == SecurityType.biometrics;
  bool get isBoth => security == SecurityType.both;
  bool get isNone => security == SecurityType.none;

  /// Creates a copy of the Preference with optional properties updated.
  Preference copyWith({
    PreferenceOption? chatNotification,
    PreferenceOption? callNotification,
    PreferenceOption? otherNotification,
    PreferenceOption? connectNotification,
    PreferenceOption? scheduleNotification,
    bool? hasBiometrics,
    ThemeType? theme,
    bool? autoConnectMeWithProvider,
    bool? warnMeOnPersonalInformationSharing,
    ScheduleTime? scheduleTime,
    SecurityType? security,
    bool? hasRequestedCountry,
    bool? remember,
    String? active
  }) {
    return Preference(
      chatNotification: chatNotification ?? this.chatNotification,
      callNotification: callNotification ?? this.callNotification,
      otherNotification: otherNotification ?? this.otherNotification,
      connectNotification: connectNotification ?? this.connectNotification,
      scheduleNotification: scheduleNotification ?? this.scheduleNotification,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      theme: theme ?? this.theme,
      autoConnectMeWithProvider: autoConnectMeWithProvider ?? this.autoConnectMeWithProvider,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      warnMeOnPersonalInformationSharing: warnMeOnPersonalInformationSharing ?? this.warnMeOnPersonalInformationSharing,
      security: security ?? this.security,
      hasRequestedCountry: hasRequestedCountry ?? this.hasRequestedCountry,
      remember: remember ?? this.remember,
      active: active ?? this.active,
    );
  }

  factory Preference.fromJson(Map<String, dynamic> map) {
    return Preference(
      chatNotification: map["chat_notification"] != null
        ? (map["chat_notification"] as String).toPreferenceOption()
        : PreferenceOption.phone,
      callNotification: map["call_notification"] != null
        ? (map["call_notification"] as String).toPreferenceOption()
        : PreferenceOption.phone,
      otherNotification: map["other_notification"] != null
        ? (map["other_notification"] as String).toPreferenceOption()
        : PreferenceOption.phone,
      connectNotification: map["connect_notification"] != null
        ? (map["connect_notification"] as String).toPreferenceOption()
        : PreferenceOption.phone,
      scheduleNotification: map["schedule_notification"] != null
        ? (map["schedule_notification"] as String).toPreferenceOption()
        : PreferenceOption.phone,
      scheduleTime: map["schedule_time"] != null
        ? (map["schedule_time"] as String).toScheduleTime()
        : ScheduleTime.thirtyMinutes,
      theme: map["theme"] != null
        ? (map["theme"] as String).toThemeType()
        : ThemeType.light,
      security: map["security"] != null
        ? (map["security"] as String).toSecurityType()
        : SecurityType.none,
      autoConnectMeWithProvider: map["auto_connect_me_with_provider"] ?? false,
      hasBiometrics: map["has_biometrics"] ?? false,
      warnMeOnPersonalInformationSharing: map["warn_me_on_personal_information_sharing"] ?? false,
      remember: map["remember"] ?? false,
      hasRequestedCountry: map["has_requested_country"] ?? false,
      active: map["active"] ?? ""
    );
  }

  Map<String, dynamic> toJson() => {
    "chat_notification": chatNotification.type,
    "call_notification": callNotification.type,
    "other_notification": otherNotification.type,
    "connect_notification": connectNotification.type,
    "schedule_notification": scheduleNotification.type,
    "has_biometrics": hasBiometrics,
    "auto_connect_me_with_provider": autoConnectMeWithProvider,
    "warn_me_on_personal_information_sharing": warnMeOnPersonalInformationSharing,
    "schedule_time": scheduleTime.type,
    "theme": theme.type,
    "security": security.type,
    "remember": remember,
    "has_requested_country": hasRequestedCountry,
    "active": active
  };
}