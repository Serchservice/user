import 'package:user/library.dart';

class SharedLinkData {
  SharedLinkData({
    required this.link,
    required this.label,
    required this.image,
    required this.amount,
    required this.status,
    required this.category,
    required this.provider,
    required this.user,
    required this.linkId,
    required this.createdAt,
  });

  final String link;
  final String label;
  final String image;
  final String amount;
  final String status;
  final String category;
  final SharedUser provider;
  final SharedUser user;
  final String linkId;
  final DateTime? createdAt;

  SharedLinkData copyWith({
    String? link,
    String? label,
    String? image,
    String? amount,
    String? status,
    String? category,
    SharedUser? provider,
    SharedUser? user,
    String? linkId,
    DateTime? createdAt,
  }) {
    return SharedLinkData(
      link: link ?? this.link,
      label: label ?? this.label,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      category: category ?? this.category,
      provider: provider ?? this.provider,
      user: user ?? this.user,
      linkId: linkId ?? this.linkId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SharedLinkData.fromJson(Map<String, dynamic> json) {
    return SharedLinkData(
      link: json["link"] ?? "",
      label: json["label"] ?? "",
      image: json["image"] ?? "",
      amount: json["amount"] ?? "",
      status: json["status"] ?? "",
      category: json["category"] ?? "",
      provider: json["provider"] != null ? SharedUser.fromJson(json["provider"]) : SharedUser.empty(),
      user: json["user"] != null ? SharedUser.fromJson(json["user"]) : SharedUser.empty(),
      linkId: json["link_id"] ?? "",
      createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"] ?? "") : DateTime.now(),
    );
  }

  factory SharedLinkData.empty() {
    return SharedLinkData.fromJson({
		"link": "string",
		"label": "string",
		"image": "string",
		"amount": "string",
		"status": "string",
		"category": "MECHANIC",
		"provider": {
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"category": "string",
			"rating": 0.0
		},
		"user": {
			"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
			"name": "string",
			"avatar": "string",
			"category": "string",
			"rating": 0.0
		},
		"link_id": "string",
		"created_at": "2024-05-10T06:43:58.969Z"
	});
  }

  Map<String, dynamic> toJson() => {
    "link": link,
    "label": label,
    "image": image,
    "amount": amount,
    "status": status,
    "category": category,
    "provider": provider.toJson(),
    "user": user.toJson(),
    "link_id": linkId,
    "created_at": createdAt?.toIso8601String(),
  };
}