class UserResponse {
  UserResponse({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.category,
    required this.image,
    required this.rating,
    required this.phone,
    required this.bookmark,
    this.tripRating,
  });

  final String id;
  final String name;
  final String avatar;
  final String role;
  final String category;
  final String image;
  final double rating;
  final String phone;
  final String bookmark;
  final double? tripRating;

  UserResponse copyWith({
    String? id,
    String? name,
    String? avatar,
    String? role,
    String? category,
    String? image,
    double? rating,
    String? phone,
    String? bookmark,
    double? tripRating,
  }) {
    return UserResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      phone: phone ?? this.phone,
      bookmark: bookmark ?? this.bookmark,
      tripRating: tripRating ?? this.tripRating,
    );
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      role: json["role"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      rating: json["rating"] ?? 0.0,
      phone: json["phone"] ?? "",
      bookmark: json["bookmark"] ?? "",
      tripRating: json["trip_rating"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "role": role,
    "category": category,
    "image": image,
    "rating": rating,
    "phone": phone,
    "bookmark": bookmark,
    "trip_rating": tripRating,
  };

  bool get isBookmarked => bookmark.isNotEmpty;
  bool get isRated => tripRating != null;
}

/*
{
	"id": "string",
	"name": "string",
	"avatar": "string",
	"role": "string",
	"category": "string",
	"image": "string",
	"rating": 0,
	"phone": "string",
	"bookmark": "string",
	"trip_rating": null
}
*/