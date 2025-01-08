import 'package:user/library.dart';

class Profile {
  Profile({
    required this.id,
    required this.category,
    required this.image,
    required this.gender,
    required this.status,
    required this.avatar,
    required this.certificate,
    required this.rating,
    required this.more,
    required this.specializations,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneInfo,
    required this.verificationStatus,
    required this.businessInformation,
  });

  final String id;
  final String category;
  final String image;
  final String gender;
  final String status;
  final String avatar;
  final String certificate;
  final double rating;
  final More more;
  final List<Specialization> specializations;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final PhoneInfo phoneInfo;
  final String verificationStatus;
  final BusinessInformation? businessInformation;

  Profile copyWith({
    String? id,
    String? category,
    String? image,
    String? gender,
    String? status,
    String? avatar,
    String? certificate,
    double? rating,
    More? more,
    List<Specialization>? specializations,
    String? firstName,
    String? lastName,
    String? emailAddress,
    PhoneInfo? phoneInfo,
    String? verificationStatus,
    BusinessInformation? businessInformation,
  }) {
    return Profile(
      id: id ?? this.id,
      category: category ?? this.category,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      certificate: certificate ?? this.certificate,
      rating: rating ?? this.rating,
      more: more ?? this.more,
      specializations: specializations ?? this.specializations,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneInfo: phoneInfo ?? this.phoneInfo,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      businessInformation: businessInformation ?? this.businessInformation,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      gender: json["gender"] ?? "",
      status: json["status"] ?? "",
      avatar: json["avatar"] ?? "",
      certificate: json["certificate"] ?? "",
      rating: json["rating"] ?? 0.0,
      more: More.fromJson(json["more"]),
      specializations: json["specializations"] == null
          ? []
          : List<Specialization>.from(json["specializations"]!.map((x) => Specialization.fromJson(x))),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      emailAddress: json["email_address"] ?? "",
      phoneInfo: PhoneInfo.fromJson(json["phone_info"]),
      verificationStatus: json["verification_status"] ?? "",
      businessInformation: json["business_information"] == null
          ? null
          : BusinessInformation.fromJson(json["business_information"]),
    );
  }

  factory Profile.empty() {
    return Profile.fromJson({
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "category": "MECHANIC",
      "image": "",
      "gender": "string",
      "status": "string",
      "avatar": "string",
      "certificate": "string",
      "rating": 0.0,
      "more": {
        "last_signed_in": "string",
        "number_of_rating": 0,
        "number_of_shops": 0,
        "total_service_trips": 0,
        "total_shared": 0
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
      "first_name": "string",
      "last_name": "string",
      "email_address": "string",
      "phone_info": {
        "phone_number": "string",
        "country_code": "string",
        "iso_code": "string",
        "country": "string"
      },
      "verification_status": "REQUESTED",
      "business_information": {
        "name": "string",
        "description": "string",
        "address": "string",
        "logo": "string"
      }
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "image": image,
    "gender": gender,
    "status": status,
    "avatar": avatar,
    "certificate": certificate,
    "rating": rating,
    "more": more.toJson(),
    "specializations": specializations.map((x) => x.toJson()).toList(),
    "first_name": firstName,
    "last_name": lastName,
    "email_address": emailAddress,
    "phone_info": phoneInfo.toJson(),
    "verification_status": verificationStatus,
    "business_information": businessInformation?.toJson(),
  };

  String get name => "$firstName $lastName";
}



/*
{
	"id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
	"category": "MECHANIC",
	"image": "",
	"gender": "string",
	"status": "string",
	"avatar": "string",
	"certificate": "string",
	"rating": 0,
	"more": {
		"last_signed_in": "string",
		"number_of_rating": 0,
		"number_of_shops": 0,
		"total_service_trips": 0,
		"total_shared": 0
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
	"first_name": "string",
	"last_name": "string",
	"email_address": "string",
	"phone_info": {
		"phone_number": "string",
		"country_code": "string",
		"iso_code": "string",
		"country": "string"
	},
	"verification_status": "REQUESTED",
	"business_information": {
		"name": "string",
		"description": "string",
		"address": "string",
		"logo": "string"
	}
}*/