class Bookmark {
  Bookmark({
    required this.id,
    required this.name,
    required this.avatar,
    required this.user,
    required this.category,
    required this.rating,
    required this.lastSignedIn,
    required this.image,
  });

  final String id;
  final String name;
  final String avatar;
  final String user;
  final String category;
  final String image;
  final double rating;
  final String lastSignedIn;

  Bookmark copyWith({
    String? id,
    String? name,
    String? avatar,
    String? user,
    String? category,
    double? rating,
    String? lastSignedIn,
    String? image,
  }) {
    return Bookmark(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      user: user ?? this.user,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
      image: image ?? this.image,
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      user: json["user"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      rating: json["rating"] ?? 0,
      lastSignedIn: json["last_signed_in"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "user": user,
    "category": category,
    "rating": rating,
    "image": image,
    "last_signed_in": lastSignedIn,
  };
}

/*
{
	"id": "string",
	"name": "string",
	"avatar": "string",
	"user": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
	"category": "string",
  "image": "string",
	"rating": 0,
	"last_signed_in": "string"
}*/