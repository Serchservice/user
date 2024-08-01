import 'package:user/library.dart';

class AuthResponse {
  AuthResponse({
    required this.id,
    required this.role,
    required this.session,
    required this.firstName,
    required this.hasMfa,
    required this.category,
    required this.image,
    required this.hasRecoveryCodes,
    required this.lastName,
    required this.rating,
    required this.avatar,
  });

  final String id;
  final String role;
  final SessionResponse session;
  final String firstName;
  final bool hasMfa;
  final String image;
  final String category;
  final bool hasRecoveryCodes;
  final String lastName;
  final double rating;
  final String avatar;

  AuthResponse copyWith({
    String? id,
    String? role,
    SessionResponse? session,
    String? firstName,
    bool? hasMfa,
    bool? hasRecoveryCodes,
    String? category,
    String? image,
    String? lastName,
    double? rating,
    String? avatar,
  }) {
    return AuthResponse(
      id: id ?? this.id,
      role: role ?? this.role,
      session: session ?? this.session,
      firstName: firstName ?? this.firstName,
      hasMfa: hasMfa ?? this.hasMfa,
      image: image ?? this.image,
      category: category ?? this.category,
      lastName: lastName ?? this.lastName,
      rating: rating ?? this.rating,
      avatar: avatar ?? this.avatar,
      hasRecoveryCodes: hasRecoveryCodes ?? this.hasRecoveryCodes,
    );
  }

  factory AuthResponse.empty() {
    return AuthResponse(
      id: "",
      role: "",
      session: SessionResponse.empty(),
      firstName: "",
      hasMfa: false,
      image: "",
      category: "",
      hasRecoveryCodes: false,
      lastName: "",
      rating: 5.0,
      avatar: "",
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json["id"] ?? "",
      role: json["role"] ?? "",
      session: json["session"] == null
          ? SessionResponse.empty()
          : SessionResponse.fromJson(json["session"]),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      hasMfa: json["has_mfa"] ?? false,
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      avatar: json["avatar"] ?? "",
      rating: json["rating"] ?? 5.0,
      hasRecoveryCodes: json["has_recovery_codes"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "session": session.toJson(),
    "first_name": firstName,
    "last_name": lastName,
    "has_mfa": hasMfa,
    "category": category,
    "avatar": avatar,
    "image": image,
    "rating": rating,
    "has_recovery_codes": hasRecoveryCodes,
  };

  String get name => "$firstName $lastName";

  /// Checks if the current user is a provider
  bool get isProvider => role == "PROVIDER";

  /// Checks if the current user is a provider
  bool get isAssociate => role == "ASSOCIATE_PROVIDER";
}