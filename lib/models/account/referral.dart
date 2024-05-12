import 'package:user/library.dart';

class Referral {
  Referral({
    required this.referId,
    required this.name,
    required this.avatar,
    required this.role,
    required this.data,
  });

  final String referId;
  final String name;
  final String avatar;
  final String role;
  final ReferralData? data;

  Referral copyWith({
    String? referId,
    String? name,
    String? avatar,
    String? role,
    ReferralData? data,
  }) {
    return Referral(
      referId: referId ?? this.referId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      data: data ?? this.data,
    );
  }

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      referId: json["referId"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      role: json["role"] ?? "",
      data: json["data"] == null ? null : ReferralData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "referId": referId,
    "name": name,
    "avatar": avatar,
    "role": role,
    "data": data?.toJson(),
  };
}

/*
{
	"referId": "string",
	"name": "string",
	"avatar": "string",
	"role": "string",
	"data": {
		"info": "string",
		"label": "string"
	}
}*/