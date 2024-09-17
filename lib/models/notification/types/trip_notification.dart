class TripNotification {
  final String snt;
  final String name;
  final String id;
  final bool canAct;
  final bool isRequest;
  final String trip;

  TripNotification({
    required this.snt,
    required this.name,
    required this.id,
    required this.canAct,
    required this.isRequest,
    required this.trip
  });

  factory TripNotification.fromJson(Map<String, dynamic> json) {
    return TripNotification(
      snt: json["snt"] ?? "",
      name: json['sender_name'] ?? "",
      id: json["sender_id"] ?? "",
      canAct: bool.parse("${json["can_act"] ?? "false"}"),
      isRequest: bool.parse("${json["is_request"] ?? "false"}"),
      trip: json["trip_id"] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "snt": snt,
      "sender_name": name,
      "sender_id": id,
      "can_act": canAct,
      "is_request": isRequest,
      "trip_id": trip,
    };
  }

  factory TripNotification.fromStringJson(Map<String, String?> json) {
    return TripNotification(
      snt: json["snt"] ?? "",
      name: json['sender_name'] ?? "",
      id: json["sender_id"] ?? "",
      canAct: json["can_act"]?.toLowerCase() == 'true',
      isRequest: json["is_request"]?.toLowerCase() == 'true',
      trip: json["trip_id"] ?? "",
    );
  }

  Map<String, String> toStringJson() {
    return {
      "snt": snt,
      "sender_name": name,
      "sender_id": id,
      "can_act": canAct.toString(),
      "is_request": isRequest.toString(),
      "trip_id": trip,
    };
  }

  TripNotification copyWith({
    String? snt,
    String? name,
    String? id,
    bool? canAct,
    bool? isRequest,
    String? trip,
  }) {
    return TripNotification(
      snt: snt ?? this.snt,
      name: name ?? this.name,
      id: id ?? this.id,
      canAct: canAct ?? this.canAct,
      isRequest: isRequest ?? this.isRequest,
      trip: trip ?? this.trip,
    );
  }
}