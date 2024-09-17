import 'package:user/library.dart';

class CallNotification {
  final String callDisplayName;
  final String createdByDisplayName;
  final String sender;
  final String receiverId;
  final String callCid;
  final String createdById;
  final String type;
  final String version;

  CallNotification({
    required this.callDisplayName,
    required this.createdByDisplayName,
    required this.sender,
    required this.receiverId,
    required this.callCid,
    required this.createdById,
    required this.type,
    required this.version,
  });

  // Convert a CallNotification into a Map.
  Map<String, dynamic> toJson() {
    return {
      'call_display_name': callDisplayName,
      'created_by_display_name': createdByDisplayName,
      'sender': sender,
      'receiver_id': receiverId,
      'call_cid': callCid,
      'created_by_id': createdById,
      'type': type,
      'version': version,
    };
  }

  Map<String, String?> toStringedJson() {
    return {
      'call_display_name': callDisplayName,
      'created_by_display_name': createdByDisplayName,
      'sender': sender,
      'receiver_id': receiverId,
      'call_cid': callCid,
      'created_by_id': createdById,
      'type': type,
      'version': version,
    };
  }

  // Create a CallNotification from a Map.
  factory CallNotification.fromJson(Map<String, dynamic> json) {
    return CallNotification(
      callDisplayName: json['call_display_name'] ?? "",
      createdByDisplayName: json['created_by_display_name'] ?? "",
      sender: json['sender'] ?? "",
      receiverId: json['receiver_id'] ?? "",
      callCid: json['call_cid'] ?? "",
      createdById: json['created_by_id'] ?? "",
      type: json['type'] ?? "",
      version: json['version'] ?? "",
    );
  }

  // Create a copy of the CallNotification with optional new values.
  CallNotification copyWith({
    String? callDisplayName,
    String? createdByDisplayName,
    String? sender,
    String? receiverId,
    String? callCid,
    String? createdById,
    String? type,
    String? version,
  }) {
    return CallNotification(
      callDisplayName: callDisplayName ?? this.callDisplayName,
      createdByDisplayName: createdByDisplayName ?? this.createdByDisplayName,
      sender: sender ?? this.sender,
      receiverId: receiverId ?? this.receiverId,
      callCid: callCid ?? this.callCid,
      createdById: createdById ?? this.createdById,
      type: type ?? this.type,
      version: version ?? this.version,
    );
  }

  bool get isRinging => type == "call.ring";

  bool get isMissed => type == "call.missed";

  // Extract the call type before the first colon
  CallType get callType => callCid.split(':').first.toCallType();

  // Extract the channel starting with SCALL by splitting the string at the colon
  String get channel => callCid.split(':').last;

  String get notificationTitle => isRinging
      ? "Incoming ${callType.type}"
      : "Missed ${callType.type}";

  String get notificationBody => isRinging
      ? createdByDisplayName
      : callDisplayName;

  ActiveCallResponse toCall() {
    return ActiveCallResponse(
      name: createdByDisplayName,
      avatar: Media.light,
      user: createdById,
      channel: channel,
      type: callType,
      isCaller: Database.auth.id == createdById,
      app: callCid,
      status: CallStatus.ringing,
      category: "",
      image: "",
      session: 0,
      snt: callSNT,
      answer: isRinging
    );
  }
}