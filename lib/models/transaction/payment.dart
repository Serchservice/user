class Payment {
  Payment({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  final String authorizationUrl;
  final String accessCode;
  final String reference;

  Payment copyWith({
    String? authorizationUrl,
    String? accessCode,
    String? reference,
  }) {
    return Payment(
      authorizationUrl: authorizationUrl ?? this.authorizationUrl,
      accessCode: accessCode ?? this.accessCode,
      reference: reference ?? this.reference,
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      authorizationUrl: json["authorization_url"] ?? "",
      accessCode: json["access_code"] ?? "",
      reference: json["reference"] ?? "",
    );
  }

  factory Payment.empty() {
    return Payment.fromJson({
      "authorization_url": "",
      "access_code": "",
      "reference": ""
    });
  }

  Map<String, dynamic> toJson() => {
    "authorization_url": authorizationUrl,
    "access_code": accessCode,
    "reference": reference,
  };
}

/*
{
	"authorization_url": "string",
	"access_code": "string",
	"reference": "string"
}*/