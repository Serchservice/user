import 'package:user/library.dart';

class SerchCategory {
  SerchCategory({
    required this.type,
    required this.image,
    required this.category,
    required this.specialties,
    required this.information
  });

  final String type;
  final String image;
  final String category;
  final String information;
  final List<Specialization> specialties;

  SerchCategory copyWith({
    String? type,
    String? image,
    String? category,
    String? information,
    List<Specialization>? specialties,
  }) {
    return SerchCategory(
      type: type ?? this.type,
      image: image ?? this.image,
      category: category ?? this.category,
      information: information ?? this.information,
      specialties: specialties ?? this.specialties,
    );
  }

  factory SerchCategory.fromJson(Map<String, dynamic> json) {
    return SerchCategory(
      type: json["type"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      information: json["information"] ?? "",
      specialties: json["specialties"] == null
        ? []
        : List<Specialization>.from(json["specialties"]!.map((x) => Specialization.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "image": image,
    "category": category,
    "information": information,
    "specialties": specialties.map((x) => x.toJson()).toList(),
  };
}

/*
{
	"type": "string",
	"image": "string",
	"category": "MECHANIC",
  "information": "",
	"specialties": [
		{
			"id": 0,
			"special": "string",
			"difficulty": "string",
			"timeline": "string",
			"category": "MECHANIC",
			"price_range": "string"
		}
	]
}*/