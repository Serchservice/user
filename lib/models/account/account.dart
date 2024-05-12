class Account {
  Account({
    required this.id,
    required this.category,
    required this.name,
    required this.avatar,
    required this.categoryImage,
    required this.linkId,
    required this.emailAddress,
  });

  final String id;
  final String category;
  final String name;
  final String avatar;
  final String categoryImage;
  final String linkId;
  final String emailAddress;

  Account copyWith({
    String? id,
    String? category,
    String? name,
    String? avatar,
    String? categoryImage,
    String? linkId,
    String? emailAddress,
  }) {
    return Account(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      categoryImage: categoryImage ?? this.categoryImage,
      linkId: linkId ?? this.linkId,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json["id"] ?? "",
      category: json["category"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      categoryImage: json["category_image"] ?? "",
      linkId: json["link_id"] ?? "",
      emailAddress: json["email_address"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "name": name,
    "avatar": avatar,
    "category_image": categoryImage,
    "link_id": linkId,
    "email_address": emailAddress,
  };
}

/*
{
	"id": "string",
	"category": "string",
	"name": "string",
	"avatar": "string",
	"category_image": "string",
	"link_id": "string",
	"email_address": "string"
}*/