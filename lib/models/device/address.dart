/// Class representing a user address.
class Address {
  /// Name of the address.
  final String place;

  /// Country
  final String country;

  /// State
  final String state;

  /// City
  final String city;

  /// Latitude of the address.
  final double latitude;

  /// Longitude of the address.
  final double longitude;

  /// THe local government area of the place.
  final String localGovernmentArea;

  /// The street number of the place.
  final String streetNumber;

  /// The street name of the place.
  final String streetName;

  /// Creates a new instance of Address with the given properties.
  const Address({
    this.latitude = 12.97,
    this.longitude = 77.58,
    this.localGovernmentArea = "",
    this.streetName = "",
    this.streetNumber = "",
    this.country = "",
    this.place = "",
    this.state = "",
    this.city = "",
  });

  /// Creates a copy of the Address with optional properties updated.
  Address copyWith({
    /// Name of the address.
    String? place,

    /// ID of the address.
    String? placeId,

    /// Longitude of the address.
    double? latitude,

    /// Latitude of the address.
    double? longitude,

    /// Country of the address
    String? country,

    /// State  of the address
    String? state,

    /// City of the address
    String? city,

    /// THe local government area of the place.
    String? localGovernmentArea,

  /// The street number of the place.
    String? streetNumber,

  /// The street name of the place.
    String? streetName,
  }) {
    return Address(
      place: place ?? this.place,
      localGovernmentArea: localGovernmentArea ?? this.localGovernmentArea,
      streetName: streetName ?? this.streetName,
      streetNumber: streetNumber ?? this.streetNumber,
      latitude: latitude ?? this.latitude,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      longitude: longitude ?? this.longitude,
    );
  }

  static Address fromJson(Map<String, dynamic> json) => Address(
    latitude: json["latitude"],
    longitude: json["longitude"],
    localGovernmentArea: json["local_government_area"],
    streetName: json['street_name'],
    streetNumber: json['street_number'],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    place: json["place_name"]
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "country": country,
    "state": state,
    "city": city,
    "local_government_area": localGovernmentArea,
    'street_name': streetName,
    'street_number': streetNumber,
    "place_name": place,
  };

  bool matches(String country, String state) {
    return country.toLowerCase() == this.country.toLowerCase()
      && state.toLowerCase() == this.state.toLowerCase();
  }
}