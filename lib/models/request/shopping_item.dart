import 'package:user/library.dart';

class ShoppingItem {
  final Address? address;
  final int amount;
  final String item;
  final int quantity;

  ShoppingItem({
    required this.item,
    required this.amount,
    this.address,
    this.quantity = 1
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      item: json["item"] ?? "",
      amount: json["amount"] ?? 0,
      address: json["address"] != null ? Address.fromJson(json["address"]) : null,
      quantity: json["quantity"] ?? 1
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "item": item,
      "amount": amount,
      "address": address?.toJson(),
      "quantity": quantity
    };
  }
}