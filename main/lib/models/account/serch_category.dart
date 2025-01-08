class SerchCategory {
  SerchCategory({
    required this.type,
    required this.image,
    required this.category,
    required this.information,
    required this.canDrive,
    required this.canSearchSkill
  });

  final String type;
  final String image;
  final String category;
  final String information;
  final bool canSearchSkill;
  final bool canDrive;

  SerchCategory copyWith({
    String? type,
    String? image,
    String? category,
    String? information,
    bool? canSearchSkill,
    bool? canDrive,
  }) {
    return SerchCategory(
      type: type ?? this.type,
      image: image ?? this.image,
      category: category ?? this.category,
      information: information ?? this.information,
      canSearchSkill: canSearchSkill ?? this.canSearchSkill,
      canDrive: canDrive ?? this.canDrive,
    );
  }

  factory SerchCategory.quick({required String header, required String image, required String mode}) {
    return SerchCategory(
      type: header,
      image: image,
      category: mode,
      information: "",
      canDrive: false,
      canSearchSkill: false
    );
  }

  bool get isPersonalShopper => category == "PERSONAL_SHOPPER";
  bool get isMechanic => category == "MECHANIC";
  bool get isPlumber => category == "PLUMBER";
  bool get isElectrician => category == "ELECTRICIAN";
  bool get isHouseKeeper => category == "HOUSE_KEEPING";
  bool get isCarpenter => category == "CARPENTER";

  factory SerchCategory.fromJson(Map<String, dynamic> json) {
    return SerchCategory(
      type: json["type"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      information: json["information"] ?? "",
      canDrive: json["can_drive"],
      canSearchSkill: json["can_search_skill"],
    );
  }

  factory SerchCategory.empty() {
    return SerchCategory.fromJson({
      "type": "",
      "image": "",
      "category": "",
      "information": "",
      "can_search_skill": false,
      "can_drive": false,
    });
  }

  Map<String, dynamic> toJson() => {
    "type": type,
    "image": image,
    "category": category,
    "information": information,
    "can_search_skill": canSearchSkill,
    "can_drive": canDrive,
  };

  factory SerchCategory.fromParams(Map<String, String> json) {
    return SerchCategory(
      type: json["type"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      information: json["information"] ?? "",
      canDrive: bool.parse(json["can_drive"] ?? "false"),
      canSearchSkill: bool.parse(json["can_search_skill"] ?? "false"),
    );
  }

  Map<String, String> toParams() => {
    "type": type,
    "image": image,
    "category": category,
    "information": information,
    "can_search_skill": canSearchSkill.toString(),
    "can_drive": canDrive.toString(),
  };
}