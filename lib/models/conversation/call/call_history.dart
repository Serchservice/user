class CallHistory {
  CallHistory({
    required this.channel,
    required this.label,
    required this.duration,
    required this.outgoing,
    required this.type,
    required this.status,
  });

  final String channel;
  final String label;
  final String duration;
  final bool outgoing;
  final String type;
  final String status;

  CallHistory copyWith({
    String? channel,
    String? label,
    String? duration,
    bool? outgoing,
    String? type,
    String? status,
  }) {
    return CallHistory(
      channel: channel ?? this.channel,
      label: label ?? this.label,
      duration: duration ?? this.duration,
      outgoing: outgoing ?? this.outgoing,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      channel: json["channel"] ?? "",
      label: json["label"] ?? "",
      duration: json["duration"] ?? "",
      outgoing: json["outgoing"] ?? false,
      type: json["type"] ?? "",
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "label": label,
    "duration": duration,
    "outgoing": outgoing,
    "type": type,
    "status": status,
  };

  /// Tells if the call was missed
  bool get isMissed => status.toLowerCase() == "missed";

  /// Tells if the call was declined
  bool get isDeclined => status.toLowerCase() == "declined";

  /// Tells if the call is a video call
  bool get isVideo => type.toLowerCase() == "video";

  /// Tells if the call is a voice call
  bool get isVoice => type.toLowerCase() == "voice";

  /// Tells if the call is a T2F call
  bool get isT2F => type.toLowerCase() == "t2f";
}