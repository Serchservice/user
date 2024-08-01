import 'package:user/library.dart';

class Transaction {
  Transaction({
    required this.recipient,
    required this.amount,
    required this.label,
    required this.status,
    required this.type,
    required this.data,
    required this.associate,
    required this.isIncoming,
  });

  final String recipient;
  final String amount;
  final String label;
  final String status;
  final String type;
  final TransactionData data;
  final TransactionProfileData? associate;
  final bool isIncoming;

  Transaction copyWith({
    String? recipient,
    String? amount,
    String? label,
    String? status,
    String? type,
    TransactionData? data,
    TransactionProfileData? associate,
    bool? isIncoming,
  }) {
    return Transaction(
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      label: label ?? this.label,
      status: status ?? this.status,
      type: type ?? this.type,
      data: data ?? this.data,
      associate: associate ?? this.associate,
      isIncoming: isIncoming ?? this.isIncoming,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      recipient: json["recipient"] ?? "",
      amount: json["amount"] ?? "",
      label: json["label"] ?? "",
      status: json["status"] ?? "",
      type: json["type"] ?? "",
      data: TransactionData.fromJson(json["data"]),
      associate: json["associate"] == null ? null : TransactionProfileData.fromJson(json["associate"]),
      isIncoming: json["is_incoming"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "recipient": recipient,
    "amount": amount,
    "label": label,
    "status": status,
    "type": type,
    "data": data.toJson(),
    "associate": associate?.toJson(),
    "is_incoming": isIncoming,
  };
}