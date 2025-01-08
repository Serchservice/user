import 'package:user/library.dart';

class Active {
  Active({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.distance,
    required this.image,
    required this.category,
    required this.status,
    required this.more,
    required this.business,
    required this.specializations,
    required this.distanceInKm,
    required this.verificationStatus,
  });

  final String id;
  final String name;
  final String avatar;
  final double rating;
  final double distance;
  final String image;
  final String category;
  final String status;
  final More? more;
  final BusinessInformation? business;
  final List<Specialization> specializations;
  final String distanceInKm;
  final String verificationStatus;

  Active copyWith({
    String? id,
    String? name,
    String? avatar,
    double? rating,
    double? distance,
    String? image,
    String? category,
    String? status,
    More? more,
    BusinessInformation? business,
    List<Specialization>? specializations,
    String? distanceInKm,
    String? verificationStatus,
  }) {
    return Active(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      image: image ?? this.image,
      category: category ?? this.category,
      status: status ?? this.status,
      more: more ?? this.more,
      business: business ?? this.business,
      specializations: specializations ?? this.specializations,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  factory Active.fromJson(Map<String, dynamic> json) {
    return Active(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      rating: json["rating"] ?? 0.0,
      distance: json["distance"] ?? 0.0,
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      status: json["status"] ?? "",
      more: json["more"] == null ? null : More.fromJson(json["more"]),
      business: json["business"] == null ? null : BusinessInformation.fromJson(json["business"]),
      specializations: json["specializations"] == null
        ? []
        : List<Specialization>.from(
            json["specializations"]!.map((x) => Specialization.fromJson(x))),
      distanceInKm: json["distance_in_km"] ?? "",
      verificationStatus: json["verification_status"] ?? "",
    );
  }

  factory Active.empty() {
    return Active.fromJson({
      "id": "",
      "name": "",
      "avatar": "",
      "rating": 0.0,
      "distance": 0.0,
      "image": "",
      "category": "",
      "status": "ONLINE",
      "more": {
        "last_signed_in": "",
        "number_of_rating": 0,
        "number_of_shops": 0,
        "total_service_trips": 0,
        "total_shared": 0
      },
      "business": {
        "name": "",
        "description": "",
        "address": "",
        "logo": ""
      },
      "specializations": [
        {
          "id": 0,
          "special": "",
          "category": "",
          "image": "",
          "avatar": ""
        }
      ],
      "distance_in_km": "",
      "verification_status": "REQUESTED"
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "rating": rating,
    "distance": distance,
    "image": image,
    "category": category,
    "status": status,
    "more": more?.toJson(),
    "business": business?.toJson(),
    "specializations": specializations.map((x) => x.toJson()).toList(),
    "distance_in_km": distanceInKm,
    "verification_status": verificationStatus,
  };
}