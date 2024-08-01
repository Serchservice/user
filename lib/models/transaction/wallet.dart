class Wallet {
  Wallet({
    required this.wallet,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.balance,
    required this.deposit,
    required this.payout,
    required this.uncleared,
    required this.payday,
    required this.payoutOnPayday,
  });

  final String wallet;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String balance;
  final String deposit;
  final String payout;
  final String uncleared;
  final int payday;
  final bool payoutOnPayday;

  Wallet copyWith({
    String? wallet,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? balance,
    String? deposit,
    String? payout,
    String? uncleared,
    int? payday,
    bool? payoutOnPayday,
  }) {
    return Wallet(
      wallet: wallet ?? this.wallet,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      balance: balance ?? this.balance,
      deposit: deposit ?? this.deposit,
      payout: payout ?? this.payout,
      uncleared: uncleared ?? this.uncleared,
      payday: payday ?? this.payday,
      payoutOnPayday: payoutOnPayday ?? this.payoutOnPayday,
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      wallet: json["wallet"] ?? "",
      accountName: json["accountName"] ?? "",
      accountNumber: json["accountNumber"] ?? "",
      bankName: json["bankName"] ?? "",
      balance: json["balance"] ?? "",
      deposit: json["deposit"] ?? "",
      payout: json["payout"] ?? "",
      uncleared: json["uncleared"] ?? "",
      payday: json["payday"] ?? 0,
      payoutOnPayday: json["payout_on_payday"] ?? false,
    );
  }

  factory Wallet.empty() {
    return Wallet.fromJson({
      "wallet": "",
      "accountName": "",
      "accountNumber": "",
      "bankName": "",
      "balance": "",
      "deposit": "",
      "payout": "",
      "uncleared": "",
      "payday": 0,
      "payout_on_payday": true
    });
  }

  Map<String, dynamic> toJson() => {
    "wallet": wallet,
    "accountName": accountName,
    "accountNumber": accountNumber,
    "bankName": bankName,
    "balance": balance,
    "deposit": deposit,
    "payout": payout,
    "uncleared": uncleared,
    "payday": payday,
    "payout_on_payday": payoutOnPayday,
  };
}

/*
{
	"wallet": "string",
	"accountName": "string",
	"accountNumber": "string",
	"bankName": "string",
	"balance": "string",
	"deposit": "string",
	"payout": "string",
	"uncleared": "string",
	"payday": 0,
	"payout_on_payday": true
}*/