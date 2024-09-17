class TransactionNotification {
  final String snt;
  final String senderName;
  final String senderId;

  TransactionNotification({
    required this.snt,
    required this.senderName,
    required this.senderId,
  });

  factory TransactionNotification.fromJson(Map<String, dynamic> json) {
    return TransactionNotification(
      snt: json['snt'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderId: json['sender_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'snt': snt,
      'sender_name': senderName,
      'sender_id': senderId,
    };
  }

  TransactionNotification copyWith({
    String? snt,
    String? senderName,
    String? senderId,
  }) {
    return TransactionNotification(
      snt: snt ?? this.snt,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
    );
  }
}
