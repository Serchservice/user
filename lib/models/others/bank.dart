class Bank {
  Bank({
    required this.name,
    required this.code,
  });

  final String name;
  final String code;

  Bank copyWith({
    String? name,
    String? code,
  }) {
    return Bank(
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
  };

  static List<Bank> list(List<dynamic> list) {
    return list.map((json) => Bank.fromJson(json)).toList();
  }
}