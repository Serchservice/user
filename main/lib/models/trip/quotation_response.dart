class QuotationResponse {
  QuotationResponse({
    required this.id,
    required this.amount,
    required this.account,
    required this.name,
    required this.avatar,
    required this.distance,
    required this.rating,
  });

  final int id;
  final String amount;
  final String account;
  final String name;
  final String avatar;
  final String distance;
  final double rating;

  QuotationResponse copyWith({
    int? id,
    String? amount,
    String? account,
    String? name,
    String? avatar,
    String? distance,
    double? rating,
  }) {
    return QuotationResponse(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      account: account ?? this.account,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
    );
  }

  factory QuotationResponse.fromJson(Map<String, dynamic> json){
    return QuotationResponse(
      id: json["id"] ?? 0,
      amount: json["amount"] ?? "",
      account: json["account"] ?? "",
      name: json["name"] ?? "",
      avatar: json["avatar"] ?? "",
      distance: json["distance"] ?? "",
      rating: json["rating"]?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "account": account,
    "name": name,
    "avatar": avatar,
    "distance": distance,
    "rating": rating,
  };
}