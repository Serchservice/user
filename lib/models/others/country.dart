import 'package:user/library.dart';

class Country {
  final String name;
  final String flag;
  final String code;
  final String dialCode;
  final int minLength;
  final int maxLength;
  final String image;

  const Country({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
    required this.minLength,
    required this.maxLength,
    required this.image
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json["name"] ?? "",
      flag: json["flag"] ?? "",
      code: json["code"] ?? "",
      dialCode: json["dialCode"] ?? "",
      minLength: json["minLength"] ?? 0,
      maxLength: json["maxLength"] ?? 0,
      image: json["image"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "flag": flag,
      "code": code,
      "dialCode": dialCode,
      "minLength": minLength,
      "maxLength": maxLength,
      "image": image,
    };
  }

  static List<Country> get countries => AppConfiguration.data.countries;

  bool matchesCountry(String value) {
    return value.toLowerCase() == name.toLowerCase();
  }

  factory Country.primary() {
    return const Country(
      name: "Nigeria",
      flag: "🇳🇬",
      code: "NG",
      dialCode: "234",
      minLength: 10,
      maxLength: 11,
      image: "https://wyvcjsumdfoamsmdzsna.supabase.co/storage/v1/object/public/flag/ng.png"
    );
  }
}