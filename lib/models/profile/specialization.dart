class Specialization {
  Specialization({
    required this.id,
    required this.special,
    required this.difficulty,
    required this.timeline,
    required this.category,
    required this.priceRange,
  });

  final int id;
  final String special;
  final String difficulty;
  final String timeline;
  final String category;
  final String priceRange;

  Specialization copyWith({
    int? id,
    String? special,
    String? difficulty,
    String? timeline,
    String? category,
    String? priceRange,
  }) {
    return Specialization(
      id: id ?? this.id,
      special: special ?? this.special,
      difficulty: difficulty ?? this.difficulty,
      timeline: timeline ?? this.timeline,
      category: category ?? this.category,
      priceRange: priceRange ?? this.priceRange,
    );
  }

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json["id"] ?? 0,
      special: json["special"] ?? "",
      difficulty: json["difficulty"] ?? "",
      timeline: json["timeline"] ?? "",
      category: json["category"] ?? "",
      priceRange: json["price_range"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "special": special,
    "difficulty": difficulty,
    "timeline": timeline,
    "category": category,
    "price_range": priceRange,
  };
}