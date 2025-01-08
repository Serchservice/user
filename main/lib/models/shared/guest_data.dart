import 'package:user/library.dart';

class GuestData {
  GuestData({
    required this.id,
    required this.gender,
    required this.avatar,
    required this.name,
    required this.status,
    required this.statuses,
    required this.joinedAt,
  });

  final String id;
  final String gender;
  final String avatar;
  final String name;
  final String status;
  final List<GuestStatus> statuses;
  final String joinedAt;

  GuestData copyWith({
    String? id,
    String? gender,
    String? avatar,
    String? name,
    String? status,
    List<GuestStatus>? statuses,
    String? joinedAt,
  }) {
    return GuestData(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      status: status ?? this.status,
      statuses: statuses ?? this.statuses,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory GuestData.fromJson(Map<String, dynamic> json) {
    return GuestData(
      id: json["id"] ?? "",
      gender: json["gender"] ?? "",
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      statuses: json["statuses"] == null
        ? []
        : List<GuestStatus>.from(json["statuses"]!.map((x) => GuestStatus.fromJson(x))),
      joinedAt: json["joined_at"] ?? "",
    );
  }

  factory GuestData.empty() {
    return GuestData.fromJson({
			"id": "string",
			"gender": "MALE",
			"avatar": "string",
			"name": "string",
			"status": "string",
			"statuses": [
				{
					"user": "string",
					"provider": "string",
					"amount": "string",
					"more": "string",
					"status": "string",
					"label": "string",
					"rating": 0.0,
					"trip": "string",
					"created_at": "2024-05-10T06:43:58.977Z"
				}
			],
			"joined_at": "string"
		});
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "gender": gender,
    "avatar": avatar,
    "name": name,
    "status": status,
    "statuses": statuses.map((x) => x.toJson()).toList(),
    "joined_at": joinedAt,
  };
}