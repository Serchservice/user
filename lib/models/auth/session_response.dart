// ignore_for_file: slash_for_doc_comments

/**
 * {
		"access_token": "string",
		"refresh_token": "string"
	}
*/
class SessionResponse {
  SessionResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  SessionResponse copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return SessionResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      accessToken: json["access_token"] ?? "",
      refreshToken: json["refresh_token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };

  factory SessionResponse.empty() {
    return SessionResponse(accessToken: "", refreshToken: "");
  }
}