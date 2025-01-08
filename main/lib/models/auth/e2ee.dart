class E2EE {
  final String privateKey;
  final String publicKey;

  E2EE({required this.privateKey, required this.publicKey});

  factory E2EE.fromJson(Map<String, dynamic> json) {
    return E2EE(
      privateKey: json["private_encryption_key"] ?? "",
      publicKey: json["public_encryption_key"] ?? ""
    );
  }

  factory E2EE.empty() => E2EE(privateKey: "", publicKey: "");

  E2EE copyWith({String? privateKey, String? publicKey}) {
    return E2EE(
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "private_encryption_key": privateKey,
      "public_encryption_key": publicKey
    };
  }
}