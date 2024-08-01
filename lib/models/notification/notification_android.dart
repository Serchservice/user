class NotificationAndroid {
  final bool directBootOk;

  NotificationAndroid({
    this.directBootOk = true,
  });

  factory NotificationAndroid.fromJson(Map<String, dynamic> json) {
    return NotificationAndroid(
      directBootOk: json['direct_boot_ok'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'direct_boot_ok': directBootOk,
    };
  }

  NotificationAndroid copyWith({
    bool? directBootOk,
  }) {
    return NotificationAndroid(
      directBootOk: directBootOk ?? this.directBootOk,
    );
  }
}
