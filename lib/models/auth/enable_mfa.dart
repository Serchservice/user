class EnableMfa {
  EnableMfa({
    required this.secret,
    required this.qrCode,
  });

  final String secret;
  final String qrCode;

  EnableMfa copyWith({
    String? secret,
    String? qrCode,
  }) {
    return EnableMfa(
      secret: secret ?? this.secret,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  factory EnableMfa.fromJson(Map<String, dynamic> json) {
    return EnableMfa(
      secret: json["secret"] ?? "",
      qrCode: json["qr_code"] ?? "",
    );
  }

  factory EnableMfa.empty() {
    return EnableMfa(
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