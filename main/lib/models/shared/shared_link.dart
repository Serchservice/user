import 'package:user/library.dart';

class SharedLink {
  SharedLink({
    required this.data,
    required this.guests,
    required this.totalGuests,
  });

  final SharedLinkData data;
  final List<GuestData> guests;
  final int totalGuests;

  SharedLink copyWith({
    SharedLinkData? data,
    List<GuestData>? guests,
    int? totalGuests,
  }) {
    return SharedLink(
      data: data ?? this.data,
      guests: guests ?? this.guests,
      totalGuests: totalGuests ?? this.totalGuests,
    );
  }

  factory SharedLink.fromJson(Map<String, dynamic> json) {
    return SharedLink(
      data: json["data"] != null ? SharedLinkData.fromJson(json["data"]) : SharedLinkData.empty(),
      guests: json["guests"] == null
        ? []
        : List<GuestData>.from(json["guests"]!.map((x) => GuestData.fromJson(x))),
      totalGuests: json["total_guests"] ?? 0,
    );
  }

  factory SharedLink.empty() {
    return SharedLink.fromJson({
      "data": {
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
          "rating": 0.0
        },
        "user": {
          "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "name": "string",
          "avatar": "string",
          "category": "string",
          "rating": 0.0
        },
        "link_id": "string",
        "created_at": "2024-05-10T06:43:58.969Z"
      },
      "guests": [
        {
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
        }
      ],
      "total_guests": 0
    });
  }

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "guests": guests.map((x) => x.toJson()).toList(),
    "total_guests": totalGuests,
  };
}

/*
{
	"data": {
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
		"created_at": "2024-05-10T06:43:58.969Z"
	},
	"guests": [
		{
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
					"rating": 0,
					"trip": "string",
					"created_at": "2024-05-10T06:43:58.977Z"
				}
			],
			"joined_at": "string"
		}
	],
	"total_guests": 0
}*/