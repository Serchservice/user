class PhoneInfo {
  PhoneInfo({
    required this.phoneNumber,
    required this.countryCode,
    required this.isoCode,
    required this.country,
  });

  final String phoneNumber;
  final String countryCode;
  final String isoCode;
  final String country;

  PhoneInfo copyWith({
    String? phoneNumber,
    String? countryCode,
    String? isoCode,
    String? country,
  }) {
    return PhoneInfo(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      isoCode: isoCode ?? this.isoCode,
      country: country ?? this.country,
    );
  }

  factory PhoneInfo.fromJson(Map<String, dynamic> json) {
    return PhoneInfo(
      phoneNumber: json["phone_number"] ?? "",
      countryCode: json["country_code"] ?? "",
      isoCode: json["iso_code"] ?? "",
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "phone_number": phoneNumber,
    "country_code": countryCode,
    "iso_code": isoCode,
    "country": country,
  };
}