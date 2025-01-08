class Specialization {
  Specialization({
    required this.id,
    required this.special,
    required this.avatar,
    required this.image,
    required this.category,
  });

  final int id;
  final String special;
  final String avatar;
  final String image;
  final String category;

  Specialization copyWith({
    int? id,
    String? special,
    String? avatar,
    String? image,
    String? category,
  }) {
    return Specialization(
      id: id ?? this.id,
      special: special ?? this.special,
      avatar: avatar ?? this.avatar,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json["id"] ?? 0,
      special: json["special"] ?? "",
      avatar: json["avatar"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
    );
  }

  factory Specialization.empty() {
    return Specialization.fromJson({
      "id": 0,
      "special": "",
      "avatar": "",
      "image": "",
      "category": "",
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "special": special,
    "avatar": avatar,
    "image": image,
    "category": category,
  };
}