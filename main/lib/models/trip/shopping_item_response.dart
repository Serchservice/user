class ShoppingItemResponse {
  ShoppingItemResponse({
    required this.id,
    required this.item,
    required this.quantity,
    required this.amount,
    required this.slip,
  });

  final int id;
  final String item;
  final int quantity;
  final String amount;
  final String slip;

  ShoppingItemResponse copyWith({
    int? id,
    String? item,
    int? quantity,
    String? amount,
    String? slip,
  }) {
    return ShoppingItemResponse(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      slip: slip ?? this.slip,
    );
  }

  factory ShoppingItemResponse.fromJson(Map<String, dynamic> json){
    return ShoppingItemResponse(
      id: json["id"] ?? 0,
      item: json["item"] ?? "",
      quantity: json["quantity"] ?? 0,
      amount: json["amount"] ?? "",
      slip: json["slip"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "quantity": quantity,
    "amount": amount,
    "slip": slip,
  };
}