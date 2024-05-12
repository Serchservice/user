import 'package:user/library.dart';

class AuthResponse {
  AuthResponse({
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
    required this.subscription,
    required this.verification,
    required this.shouldSubscribe
  });

  final String role;
  final Session session;
  final String firstName;
  final bool hasMfa;
  final String image;
  final String category;
  final bool hasRecoveryCodes;
  final String lastName;
  final double rating;
  final String avatar;
  final String subscription;
  final String verification;
  final bool shouldSubscribe;

  AuthResponse copyWith({
    String? role,
    Session? session,
    String? firstName,
    bool? hasMfa,
    bool? hasRecoveryCodes,
    String? category,
    String? image,
    String? lastName,
    double? rating,
    String? avatar,
    String? verification,
    String? subscription,
    bool? shouldSubscribe
  }) {
    return AuthResponse(
      role: role ?? this.role,
      session: session ?? this.session,
      firstName: firstName ?? this.firstName,
      hasMfa: hasMfa ?? this.hasMfa,
      image: image ?? this.image,
      category: category ?? this.category,
      lastName: lastName ?? this.lastName,
      rating: rating ?? this.rating,
      avatar: avatar ?? this.avatar,
      verification: verification ?? this.verification,
      subscription: subscription ?? this.subscription,
      shouldSubscribe: shouldSubscribe ?? this.shouldSubscribe,
      hasRecoveryCodes: hasRecoveryCodes ?? this.hasRecoveryCodes,
    );
  }

  factory AuthResponse.empty() {
    return AuthResponse(
      role: "",
      session: Session.empty(),
      firstName: "",
      hasMfa: false,
      image: "",
      category: "",
      hasRecoveryCodes: false,
      lastName: "",
      rating: 5.0,
      avatar: "",
      verification: "",
      subscription: "",
      shouldSubscribe: true
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      role: json["role"] ?? "",
      session: json["session"] == null
        ? Session.empty()
        : Session.fromJson(json["session"]),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      hasMfa: json["has_mfa"] ?? false,
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      avatar: json["avatar"] ?? "",
      verification: json["verification"] ?? "",
      subscription: json["subscription"] ?? "",
      shouldSubscribe: json["should_subscribe"] ?? true,
      rating: json["rating"] ?? 5.0,
      hasRecoveryCodes: json["has_recovery_codes"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "role": role,
    "session": session.toJson(),
    "first_name": firstName,
    "last_name": lastName,
    "has_mfa": hasMfa,
    "category": category,
    "avatar": avatar,
    "image": image,
    "verification": verification,
    "subscription": subscription,
    "should_subscribe": shouldSubscribe,
    "rating": rating,
    "has_recovery_codes": hasRecoveryCodes,
  };

  String get name => "$firstName $lastName";

  /// PREMIUM Subscription
  bool get isPremium => subscription.isNotEmpty && subscription == "PREMIUM";

  /// ALL DAY Subscription
  bool get isAllDay => subscription.isNotEmpty && subscription == "ALL_DAY";

  /// Pay As You Use Subscription
  bool get isPayAsYouUse => subscription.isNotEmpty && subscription == "PAYU";

  /// Free Subscription
  bool get isFree => subscription.isNotEmpty && subscription == "FREE";

  /// Verification Pending
  bool get isPending => verification.isNotEmpty && verification == "PENDING";

  /// Verification Error
  bool get isError => verification.isNotEmpty && verification == "ERROR";

  /// Verification Successful
  bool get isVerifed => verification.isNotEmpty && verification == "VERIFIED";

  /// Verification Not Started
  bool get isNotVerified => (verification.isNotEmpty && verification == "NOT_VERIFIED") || verification.isEmpty;
}

/*
{
	"role": "string",
	"session": {
		"access_token": "string",
		"refresh_token": "string"
	},
	"first_name": "string",
  "last_name": "string",
	"has_mfa": true,
  "image": "",
  "category": "",
  "avatar": "",
  "verification": "",
  "subscription": "",
  "should_subscribe": false,
  "rating": 5.0,
	"has_recovery_codes": true
}*/