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
			"id": "",
			"name": "",
			"avatar": "",
			"category": "",
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

  bool get isPersonalShopper => category.toLowerCase().contains("personal");
  bool get isMechanic => category.toLowerCase().contains("mechanic");
  bool get isPlumber => category.toLowerCase().contains("plumber");
  bool get isElectrician => category.toLowerCase().contains("electrician");
  bool get isHouseKeeper => category.toLowerCase().contains("house");
  bool get isCarpenter => category.toLowerCase().contains("carpenter");
}