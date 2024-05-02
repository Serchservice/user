class ReferralProgramData {
  ReferralProgramData({
    required this.referralCode,
    required this.referLink,
    required this.credits,
    required this.description,
    required this.credit,
    required this.reward,
  });

  final String referralCode;
  final String referLink;
  final double credits;
  final String description;
  final int credit;
  final String reward;

  ReferralProgramData copyWith({
    String? referralCode,
    String? referLink,
    double? credits,
    String? description,
    int? credit,
    String? reward,
  }) {
    return ReferralProgramData(
      referralCode: referralCode ?? this.referralCode,
      referLink: referLink ?? this.referLink,
      credits: credits ?? this.credits,
      description: description ?? this.description,
      credit: credit ?? this.credit,
      reward: reward ?? this.reward,
    );
  }

  factory ReferralProgramData.fromJson(Map<String, dynamic> json) {
    return ReferralProgramData(
      referralCode: json["referralCode"] ?? "",
      referLink: json["referLink"] ?? "",
      credits: json["credits"] ?? 0,
      description: json["description"] ?? "",
      credit: json["credit"] ?? 0,
      reward: json["reward"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "referralCode": referralCode,
    "referLink": referLink,
    "credits": credits,
    "description": description,
    "credit": credit,
    "reward": reward,
  };
}