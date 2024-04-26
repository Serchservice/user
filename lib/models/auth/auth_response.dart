import 'package:user/library.dart';

class AuthResponse {
  AuthResponse({
    required this.role,
    required this.session,
    required this.firstName,
    required this.hasMfa,
    required this.hasRecoveryCodes,
  });

  final String role;
  final Session session;
  final String firstName;
  final bool hasMfa;
  final bool hasRecoveryCodes;

  AuthResponse copyWith({
    String? role,
    Session? session,
    String? firstName,
    bool? hasMfa,
    bool? hasRecoveryCodes,
  }) {
    return AuthResponse(
      role: role ?? this.role,
      session: session ?? this.session,
      firstName: firstName ?? this.firstName,
      hasMfa: hasMfa ?? this.hasMfa,
      hasRecoveryCodes: hasRecoveryCodes ?? this.hasRecoveryCodes,
    );
  }

  factory AuthResponse.empty() {
    return AuthResponse(
      role: "",
      session: Session.empty(),
      firstName: "",
      hasMfa: false,
      hasRecoveryCodes: false,
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      role: json["role"] ?? "",
      session: json["session"] == null
        ? Session.empty()
        : Session.fromJson(json["session"]),
      firstName: json["first_name"] ?? "",
      hasMfa: json["has_mfa"] ?? false,
      hasRecoveryCodes: json["has_recovery_codes"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "role": role,
    "session": session.toJson(),
    "first_name": firstName,
    "has_mfa": hasMfa,
    "has_recovery_codes": hasRecoveryCodes,
  };
}

/*
{
	"role": "string",
	"session": {
		"access_token": "string",
		"refresh_token": "string"
	},
	"first_name": "string",
	"has_mfa": true,
	"has_recovery_codes": true
}*/