import 'package:user/library.dart';

class TransactionGroup {
  TransactionGroup({
    required this.label,
    required this.transactions,
  });

  final String label;
  final List<Transaction> transactions;

  TransactionGroup copyWith({
    String? label,
    List<Transaction>? transactions,
  }) {
    return TransactionGroup(
      label: label ?? this.label,
      transactions: transactions ?? this.transactions,
    );
  }

  factory TransactionGroup.fromJson(Map<String, dynamic> json) {
    return TransactionGroup(
      label: json["label"] ?? "",
      transactions: json["transactions"] == null
        ? []
        : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "label": label,
    "transactions": transactions.map((x) => x.toJson()).toList(),
  };
}

/*
{
	"label": "string",
	"transactions": [
		{
			"recipient": "string",
			"amount": "string",
			"label": "string",
			"status": "PENDING",
			"type": "FUNDING",
			"data": {
				"id": "string",
				"name": "string",
				"header": "string",
				"description": "string",
				"reference": "string",
				"mode": "string",
				"date": "string",
				"updated_at": "string"
			},
			"associate": {
				"name": "string",
				"category": "string",
				"rating": 0,
				"avatar": "string",
				"image": "string"
			},
			"is_incoming": true
		}
	]
}*/