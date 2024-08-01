class MfaRecoveryCodeResponse {
  MfaRecoveryCodeResponse({
    required this.code,
    required this.isUsed,
  });

  final String code;
  final bool isUsed;

  MfaRecoveryCodeResponse copyWith({
    String? code,
    bool? isUsed,
  }) {
    return MfaRecoveryCodeResponse(
      code: code ?? this.code,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  factory MfaRecoveryCodeResponse.fromJson(Map<String, dynamic> json) {
    return MfaRecoveryCodeResponse(
      code: json["code"] ?? "",
      isUsed: json["is_used"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "is_used": isUsed,
  };
}

/*
{
	"code": "string",
	"is_used": true
}*/