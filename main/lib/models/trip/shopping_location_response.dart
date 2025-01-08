class ShoppingLocationResponse {
  ShoppingLocationResponse({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
  });

  final String address;
  final double latitude;
  final double longitude;
  final String placeId;

  ShoppingLocationResponse copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? placeId,
  }) {
    return ShoppingLocationResponse(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
    );
  }

  factory ShoppingLocationResponse.fromJson(Map<String, dynamic> json){
    return ShoppingLocationResponse(
      address: json["address"] ?? "",
      latitude: json["latitude"] ?? 0.0,
      longitude: json["longitude"] ?? 0.0,
      placeId: json["place_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "place_id": placeId,
  };
}