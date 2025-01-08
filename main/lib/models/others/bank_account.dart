class BankAccount {
  BankAccount({
    required this.accountNumber,
    required this.accountName,
  });

  final String accountNumber;
  final String accountName;

  BankAccount copyWith({
    String? accountNumber,
    String? accountName,
  }) {
    return BankAccount(
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
    );
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['account_number'] ?? '',
      accountName: json['account_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'account_number': accountNumber,
    'account_name': accountName,
  };
}