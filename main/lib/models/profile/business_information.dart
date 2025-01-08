class BusinessInformation {
  BusinessInformation({
    required this.name,
    required this.description,
    required this.address,
    required this.logo,
  });

  final String name;
  final String description;
  final String address;
  final String logo;

  BusinessInformation copyWith({
    String? name,
    String? description,
    String? address,
    String? logo,
  }) {
    return BusinessInformation(
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      logo: logo ?? this.logo,
    );
  }

  factory BusinessInformation.fromJson(Map<String, dynamic> json) {
    return BusinessInformation(
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      address: json["address"] ?? "",
      logo: json["logo"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "address": address,
    "logo": logo,
  };
}