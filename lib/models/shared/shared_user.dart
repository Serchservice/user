class SharedUser {
  SharedUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.category,
    required this.rating,
  });

  final String id;
  final String name;
  final String avatar;
  final String category;
  final double rating;

  SharedUser copyWith({
    String? id,
    String? name,
    String? avatar,
    String? category,
    double? rating,
  }) {
    return SharedUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      category: category ?? this.category,
      rating: rating ?? this.rating,
    );
  }

  factory SharedUser.fromJson(Map<String, dynamic> json) {
    return SharedUser(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      category: json["category"] ?? "",
      rating: json["rating"] ?? 0.0,
    );
  }

  factory SharedUser.empty() {
    return SharedUser.fromJson({
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"category": "string",
			"rating": 0.0
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "category": category,
    "rating": rating,
  };
}