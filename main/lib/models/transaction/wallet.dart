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
    required this.nextPayday,
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
  final String nextPayday;

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
    String? nextPayday,
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
      nextPayday: nextPayday ?? this.nextPayday,
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      wallet: json["wallet"] ?? "",
      accountName: json["account_name"] ?? "",
      accountNumber: json["account_number"] ?? "",
      bankName: json["bank_name"] ?? "",
      balance: json["balance"] ?? "",
      deposit: json["deposit"] ?? "",
      payout: json["payout"] ?? "",
      uncleared: json["uncleared"] ?? "",
      payday: json["payday"] ?? 0,
      payoutOnPayday: json["payout_on_payday"] ?? false,
      nextPayday: json["next_payday"] ?? "",
    );
  }

  factory Wallet.empty() {
    return Wallet.fromJson({
      "wallet": "",
      "account_name": "",
      "account_number": "",
      "bank_name": "",
      "balance": "",
      "deposit": "",
      "payout": "",
      "uncleared": "",
      "payday": 0,
      "payout_on_payday": true,
      "next_payday": "",
    });
  }

  Map<String, dynamic> toJson() => {
    "wallet": wallet,
    "account_name": accountName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "balance": balance,
    "deposit": deposit,
    "payout": payout,
    "uncleared": uncleared,
    "payday": payday,
    "payout_on_payday": payoutOnPayday,
    "next_payday": nextPayday,
  };
}