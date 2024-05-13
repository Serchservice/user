import 'package:user/library.dart';

class Active {
  Active({
    required this.id,
    required this.name,
    required this.avatar,
    required this.distance,
    required this.rating,
    required this.image,
    required this.category,
    required this.status,
    required this.more,
    required this.business,
    required this.specializations,
    required this.verificationStatus,
  });

  final String id;
  final String name;
  final String avatar;
  final String distance;
  final int rating;
  final String image;
  final String category;
  final String status;
  final More? more;
  final BusinessInformation? business;
  final List<Specialization> specializations;
  final String verificationStatus;

  Active copyWith({
    String? id,
    String? name,
    String? avatar,
    String? distance,
    int? rating,
    String? image,
    String? category,
    String? status,
    More? more,
    BusinessInformation? business,
    List<Specialization>? specializations,
    String? verificationStatus,
  }) {
    return Active(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      category: category ?? this.category,
      status: status ?? this.status,
      more: more ?? this.more,
      business: business ?? this.business,
      specializations: specializations ?? this.specializations,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  factory Active.fromJson(Map<String, dynamic> json) {
    return Active(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      distance: json["distance"] ?? "",
      rating: json["rating"] ?? 0,
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      status: json["status"] ?? "",
      more: json["more"] == null ? null : More.fromJson(json["more"]),
      business: json["business"] == null ? null : BusinessInformation.fromJson(json["business"]),
      specializations: json["specializations"] == null
        ? []
        : List<Specialization>.from(json["specializations"]!.map((x) => Specialization.fromJson(x))),
      verificationStatus: json["verification_status"] ?? "",
    );
  }

  factory Active.empty() {
    return Active.fromJson({
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "name": "string",
      "avatar": "string",
      "distance": "string",
      "rating": 0.0,
      "image": "string",
      "category": "string",
      "status": "ONLINE",
      "more": {
        "last_signed_in": "string",
        "number_of_rating": 0,
        "number_of_shops": 0,
        "total_service_trips": 0,
        "total_shared": 0
      },
      "business": {
        "name": "string",
        "description": "string",
        "address": "string",
        "logo": "string"
      },
      "specializations": [
        {
          "id": 0,
          "special": "string",
          "difficulty": "string",
          "timeline": "string",
          "category": "MECHANIC",
          "price_range": "string"
        }
      ],
      "verification_status": "REQUESTED"
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "distance": distance,
    "rating": rating,
    "image": image,
    "category": category,
    "status": status,
    "more": more?.toJson(),
    "business": business?.toJson(),
    "specializations": specializations.map((x) => x.toJson()).toList(),
    "verification_status": verificationStatus,
  };
}
