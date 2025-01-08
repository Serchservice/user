import 'package:user/library.dart';

class Guest {
  Guest({
    required this.id,
    required this.gender,
    required this.avatar,
    required this.confirmed,
    required this.link,
    required this.statuses,
    required this.emailAddress,
    required this.firstName,
    required this.lastName,
    required this.joinedAt,
  });

  final String id;
  final String gender;
  final String avatar;
  final bool confirmed;
  final SharedLinkData link;
  final List<GuestStatus> statuses;
  final String emailAddress;
  final String firstName;
  final String lastName;
  final String joinedAt;

  Guest copyWith({
    String? id,
    String? gender,
    String? avatar,
    bool? confirmed,
    SharedLinkData? link,
    List<GuestStatus>? statuses,
    String? emailAddress,
    String? firstName,
    String? lastName,
    String? joinedAt,
  }) {
    return Guest(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      confirmed: confirmed ?? this.confirmed,
      link: link ?? this.link,
      statuses: statuses ?? this.statuses,
      emailAddress: emailAddress ?? this.emailAddress,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json["id"] ?? "",
      gender: json["gender"] ?? "",
      avatar: json["avatar"] ?? "",
      confirmed: json["confirmed"] ?? false,
      link: json["link"] == null ? SharedLinkData.empty() : SharedLinkData.fromJson(json["link"]),
      statuses: json["statuses"] == null
        ? []
        : List<GuestStatus>.from(json["statuses"]!.map((x) => GuestStatus.fromJson(x))),
      emailAddress: json["email_address"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      joinedAt: json["joined_at"] ?? "",
    );
  }

  factory Guest.empty() {
    return Guest.fromJson({});
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "gender": gender,
    "avatar": avatar,
    "confirmed": confirmed,
    "link": link.toJson(),
    "statuses": statuses.map((x) => x.toJson()).toList(),
    "email_address": emailAddress,
    "first_name": firstName,
    "last_name": lastName,
    "joined_at": joinedAt,
  };

  String get name => "$firstName $lastName";
}

/*
{
	"id": "string",
	"gender": "string",
	"avatar": "string",
	"confirmed": true,
	"link": {
		"link": "string",
		"label": "string",
		"image": "string",
		"amount": "string",
		"status": "string",
		"category": "MECHANIC",
		"provider": {
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"category": "string",
			"rating": 0
		},
		"user": {
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"category": "string",
			"rating": 0
		},
		"link_id": "string",
		"created_at": "2024-05-10T06:48:15.623Z"
	},
	"statuses": [
		{
			"user": "string",
			"provider": "string",
			"amount": "string",
			"more": "string",
			"status": "string",
			"label": "string",
			"rating": 0,
			"trip": "string",
			"created_at": "2024-05-10T06:48:15.623Z"
		}
	],
	"email_address": "string",
	"first_name": "string",
	"last_name": "string",
	"joined_at": "string"
}*/