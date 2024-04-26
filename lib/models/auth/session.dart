// ignore_for_file: slash_for_doc_comments

/**
 * {
		"access_token": "string",
		"refresh_token": "string"
	}
*/
class Session {
  Session({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  Session copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json["access_token"] ?? "",
      refreshToken: json["refresh_token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };

  factory Session.empty() {
    return Session(accessToken: "", refreshToken: "");
  }
}