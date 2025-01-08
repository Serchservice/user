class EnableMfaResponse {
  EnableMfaResponse({
    required this.secret,
    required this.qrCode,
  });

  final String secret;
  final String qrCode;

  EnableMfaResponse copyWith({
    String? secret,
    String? qrCode,
  }) {
    return EnableMfaResponse(
      secret: secret ?? this.secret,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  factory EnableMfaResponse.fromJson(Map<String, dynamic> json) {
    return EnableMfaResponse(
      secret: json["secret"] ?? "",
      qrCode: json["qr_code"] ?? "",
    );
  }

  factory EnableMfaResponse.empty() {
    return EnableMfaResponse(
      secret: "",
      qrCode: "",
    );
  }

  Map<String, dynamic> toJson() => {
    "secret": secret,
    "qr_code": qrCode,
  };
}

/*
{
	"secret": "string",
	"qr_code": "string"
}*/