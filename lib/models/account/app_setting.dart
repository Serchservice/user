import 'package:user/library.dart';

class AppSetting {
  AppSetting({
    required this.gender,
  });

  final Gender gender;

  AppSetting copyWith({
    Gender? gender,
  }) {
    return AppSetting(
      gender: gender ?? this.gender,
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json) {
    return AppSetting(
      gender: json["gender"] != null
        ? (json["gender"] as String).toGender()
        : Gender.any,
    );
  }

  factory AppSetting.empty() {
    return AppSetting(
      gender: Gender.none
    );
  }

  Map<String, dynamic> toJson() => {
    "gender": gender.key,
  };
}

/*
{
	"gender": "MALE"
}*/