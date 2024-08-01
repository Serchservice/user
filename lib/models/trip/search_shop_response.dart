import 'package:user/library.dart';

class SearchShopResponse {
  SearchShopResponse({
    required this.user,
    required this.distance,
    required this.shop,
    required this.distanceInKm,
  });

  final String user;
  final double distance;
  final Shop shop;
  final String distanceInKm;

  SearchShopResponse copyWith({
    String? user,
    double? distance,
    Shop? shop,
    String? distanceInKm,
  }) {
    return SearchShopResponse(
      user: user ?? this.user,
      distance: distance ?? this.distance,
      shop: shop ?? this.shop,
      distanceInKm: distanceInKm ?? this.distanceInKm,
    );
  }

  factory SearchShopResponse.fromJson(Map<String, dynamic> json) {
    return SearchShopResponse(
      user: json["user"] ?? "",
      distance: json["distance"] ?? 0.0,
      shop: Shop.fromJson(json["shop"]),
      distanceInKm: json["distance_in_km"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user,
    "distance": distance,
    "shop": shop.toJson(),
    "distance_in_km": distanceInKm,
  };
}