class MfaRecoveryCode {
  MfaRecoveryCode({
    required this.code,
    required this.isUsed,
  });

  final String code;
  final bool isUsed;

  MfaRecoveryCode copyWith({
    String? code,
    bool? isUsed,
  }) {
    return MfaRecoveryCode(
      code: code ?? this.code,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  factory MfaRecoveryCode.fromJson(Map<String, dynamic> json) {
    return MfaRecoveryCode(
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