class More {
  More({
    required this.lastSignedIn,
    required this.numberOfRating,
    required this.numberOfShops,
    required this.totalServiceTrips,
    required this.totalShared,
  });

  final String lastSignedIn;
  final int numberOfRating;
  final int numberOfShops;
  final int totalServiceTrips;
  final int totalShared;

  More copyWith({
    String? lastSignedIn,
    int? numberOfRating,
    int? numberOfShops,
    int? totalServiceTrips,
    int? totalShared,
  }) {
    return More(
      lastSignedIn: lastSignedIn ?? this.lastSignedIn,
      numberOfRating: numberOfRating ?? this.numberOfRating,
      numberOfShops: numberOfShops ?? this.numberOfShops,
      totalServiceTrips: totalServiceTrips ?? this.totalServiceTrips,
      totalShared: totalShared ?? this.totalShared,
    );
  }

  factory More.fromJson(Map<String, dynamic> json) {
    return More(
      lastSignedIn: json["last_signed_in"] ?? "",
      numberOfRating: json["number_of_rating"] ?? 0,
      numberOfShops: json["number_of_shops"] ?? 0,
      totalServiceTrips: json["total_service_trips"] ?? 0,
      totalShared: json["total_shared"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "last_signed_in": lastSignedIn,
    "number_of_rating": numberOfRating,
    "number_of_shops": numberOfShops,
    "total_service_trips": totalServiceTrips,
    "total_shared": totalShared,
  };
}