class Dashboard {
  Dashboard({
    required this.name,
    required this.avatar,
    required this.earning,
    required this.trip,
    required this.schedule,
    required this.shared,
    required this.rating,
  });

  final String name;
  final String avatar;
  final String earning;
  final String trip;
  final String schedule;
  final String shared;
  final String rating;

  Dashboard copyWith({
    String? name,
    String? avatar,
    String? earning,
    String? trip,
    String? schedule,
    String? shared,
    String? rating,
  }) {
    return Dashboard(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      earning: earning ?? this.earning,
      trip: trip ?? this.trip,
      schedule: schedule ?? this.schedule,
      shared: shared ?? this.shared,
      rating: rating ?? this.rating,
    );
  }

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      earning: json["earning"] ?? "",
      trip: json["trip"] ?? "",
      schedule: json["schedule"] ?? "",
      shared: json["shared"] ?? "",
      rating: json["rating"] ?? "",
    );
  }

  factory Dashboard.empty() {
    return Dashboard.fromJson({
      "name": "string",
      "avatar": "string",
      "earning": "string",
      "trip": "string",
      "schedule": "string",
      "shared": "string",
      "rating": "string"
    });
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "avatar": avatar,
    "earning": earning,
    "trip": trip,
    "schedule": schedule,
    "shared": shared,
    "rating": rating,
  };
}

/*
{
	"name": "string",
	"avatar": "string",
	"earning": "string",
	"trip": "string",
	"schedule": "string",
	"shared": "string",
	"rating": "string"
}*/