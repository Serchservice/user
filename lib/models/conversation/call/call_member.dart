class CallMember {
  CallMember({
    required this.member,
    required this.name,
    required this.avatar,
    required this.category,
    required this.image
  });

  final String member;
  final String name;
  final String avatar;
  final String category;
  final String image;

  CallMember copyWith({
    String? member,
    String? name,
    String? avatar,
    String? category,
    String? image,
  }) {
    return CallMember(
      member: member ?? this.member,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  factory CallMember.fromJson(Map<String, dynamic> json) {
    return CallMember(
      member: json["member"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "member": member,
    "name": name,
    "avatar": avatar,
    "category": category,
    "image": image,
  };
}
