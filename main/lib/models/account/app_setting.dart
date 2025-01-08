import 'package:user/library.dart';

class AppSetting {
  final Gender gender;
  final bool showOnlyVerified;
  final bool showOnlyCertified;

  AppSetting({
    required this.gender,
    required this.showOnlyVerified,
    required this.showOnlyCertified,
  });

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      gender: json['gender'] != null
          ? (json['gender'] as String).toGender()
          : Gender.any,
      showOnlyVerified: json['show_only_verified'] ?? false,
      showOnlyCertified: json['show_only_certified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender.key,
      'show_only_verified': showOnlyVerified,
      'show_only_certified': showOnlyCertified,
    };
  }

  AppSetting copyWith({
    Gender? gender,
    bool? showOnlyVerified,
    bool? showOnlyCertified,
  }) {
    return AppSetting(
      gender: gender ?? this.gender,
      showOnlyVerified: showOnlyVerified ?? this.showOnlyVerified,
      showOnlyCertified: showOnlyCertified ?? this.showOnlyCertified,
    );
  }

  factory AppSetting.empty() {
    return AppSetting(
      gender: Gender.any,
      showOnlyVerified: false,
      showOnlyCertified: false,
    );
  }
}