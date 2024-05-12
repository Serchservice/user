class ReferralData {
  ReferralData({
    required this.info,
    required this.label,
  });

  final String info;
  final String label;

  ReferralData copyWith({
    String? info,
    String? label,
  }) {
    return ReferralData(
      info: info ?? this.info,
      label: label ?? this.label,
    );
  }

  factory ReferralData.fromJson(Map<String, dynamic> json) {
    return ReferralData(
      info: json["info"] ?? "",
      label: json["label"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "info": info,
    "label": label,
  };
}