class Wallet {
  Wallet({
    required this.accountName,
    required this.accountNumber,
    required this.withdrawable,
    required this.bankName,
    required this.balance,
  });

  final String accountName;
  final String accountNumber;
  final String withdrawable;
  final String bankName;
  final String balance;

  Wallet copyWith({
    String? accountName,
    String? accountNumber,
    String? withdrawable,
    String? bankName,
    String? balance,
  }) {
    return Wallet(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      withdrawable: withdrawable ?? this.withdrawable,
      bankName: bankName ?? this.bankName,
      balance: balance ?? this.balance,
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      accountName: json["accountName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      withdrawable: json["withdrawable"] ?? "",
      bankName: json["bankName"] ?? "",
      balance: json["balance"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "accountName": accountName,
    "accountNumber": accountNumber,
    "withdrawable": withdrawable,
    "bankName": bankName,
    "balance": balance,
  };
}

/*
{
	"accountName": "string",
	"accountNumber": "string",
	"withdrawable": "string",
	"bankName": "string",
	"balance": "string"
}*/