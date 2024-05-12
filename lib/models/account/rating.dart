class Rating {
  Rating({
    required this.name,
    required this.rating,
    required this.comment,
    required this.category,
    required this.image,
  });

  final String name;
  final double rating;
  final String comment;
  final String category;
  final String image;

  Rating copyWith({
    String? name,
    double? rating,
    String? comment,
    String? category,
    String? image,
  }) {
    return Rating(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      name: json["name"] ?? "",
      rating: json["rating"] ?? 0,
      comment: json["comment"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "rating": rating,
    "comment": comment,
    "category": category,
    "image": image,
  };
}

/*
{
	"name": "string",
	"rating": 0,
	"comment": "string",
	"category": "string",
	"image": ""
}*/