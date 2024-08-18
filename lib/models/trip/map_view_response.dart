class MapViewResponse {
  final double latitude;
  final double longitude;
  final double heading;
  final String place;

  const MapViewResponse({
    required this.latitude,
    required this.heading,
    required this.place,
    required this.longitude
  });

  factory MapViewResponse.fromJson(Map<String, dynamic> json) {
    return MapViewResponse(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      heading: json['heading']?.toDouble() ?? 0.0,
      place: json['place'] ?? ""
    );
  }

  factory MapViewResponse.empty() {
    return const MapViewResponse(latitude: 0.0, heading: 0.0, place: "", longitude: 0.0);
  }

  MapViewResponse copyWith({
    String? place,
    double? latitude,
    double? longitude,
    double? heading,
  }) {
    return MapViewResponse(
      place: place ?? this.place,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heading: heading ?? this.heading,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "heading": heading,
      "place": place
    };
  }

  bool get isNotEmpty => latitude != 0.0 && longitude != 0.0;
}