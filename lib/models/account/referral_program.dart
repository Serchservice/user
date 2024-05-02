import 'package:user/library.dart';

class ReferralProgram {
  ReferralProgram({
    required this.name,
    required this.avatar,
    required this.role,
    required this.data,
  });

  final String name;
  final String avatar;
  final String role;
  final ReferralProgramData data;

  ReferralProgram copyWith({
    String? name,
    String? avatar,
    String? role,
    ReferralProgramData? data,
  }) {
    return ReferralProgram(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      data: data ?? this.data,
    );
  }

  factory ReferralProgram.fromJson(Map<String, dynamic> json) {
    return ReferralProgram(
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      role: json["role"] ?? "",
      data: ReferralProgramData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
    "role": role,
    "data": data.toJson(),
  };
}

/*
{
	"name": "string",
	"avatar": "string",
	"role": "string",
	"data": {
		"referralCode": "string",
		"referLink": "string",
		"credits": 0,
		"description": "string",
		"credit": 0,
		"reward": "REFER_TIERED"
	}
}*/