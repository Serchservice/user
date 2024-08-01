import 'package:user/enums/library.dart';

class ActiveCallResponse {
  final String app;
  final CallStatus status;
  final String channel;
  final String name;
  final CallType type;
  final String user;
  final String category;
  final String image;
  final String avatar;
  final int session;
  final bool isCaller;
  final String? error;
  final String? errorCode;
  final String snt;

  ActiveCallResponse({
    required this.app,
    required this.status,
    required this.channel,
    required this.name,
    required this.type,
    required this.user,
    required this.category,
    required this.image,
    required this.avatar,
    required this.session,
    required this.isCaller,
    this.error,
    this.errorCode,
    required this.snt,
  });

  factory ActiveCallResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ActiveCallResponse.fromStringedJson(
        json.map((key, value) => MapEntry(key, value.toString())),
      );
    } catch (_) {
      return ActiveCallResponse(
        app: json["app"] ?? "",
        status: json["status"] != null
            ? (json["status"] as String).toCallStatus()
            : CallStatus.disconnected,
        channel: json["channel"] ?? "",
        name: json["name"] ?? "",
        type: json["type"] != null
            ? (json["type"] as String).toCallType()
            : CallType.voice,
        user: json["user"] ?? "",
        category: json["category"] ?? "",
        image: json["image"] ?? "",
        avatar: json["avatar"] ?? "",
        session: json["session"] ?? 0,
        isCaller: json["is_caller"] ?? false,
        error: json["error"],
        errorCode: json["error_code"],
        snt: json["snt"] ?? "",
      );
    }
  }

  factory ActiveCallResponse.fromStringedJson(Map<String, String?> json) {
    return ActiveCallResponse(
      app: json["app"] ?? "",
      status: json["status"]?.toCallStatus() ?? CallStatus.disconnected,
      channel: json["channel"] ?? "",
      name: json["name"] ?? "",
      type: json["type"]?.toCallType() ?? CallType.voice,
      user: json["user"] ?? "",
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      avatar: json["avatar"] ?? "",
      session: int.tryParse(json["session"] ?? "") ?? 0,
      isCaller: json["is_caller"]?.toLowerCase() == 'true',
      error: json["error"],
      errorCode: json["error_code"],
      snt: json["snt"] ?? "",
    );
  }

  factory ActiveCallResponse.empty() {
    return ActiveCallResponse(
      app: "",
      status: CallStatus.calling,
      channel: "",
      name: "",
      type: CallType.voice,
      user: "",
      category: "",
      image: "",
      avatar: "",
      session: 0,
      isCaller: false,
      error: null,
      errorCode: null,
      snt: "",
    );
  }

  factory ActiveCallResponse.call({
    required String name,
    required String avatar,
    required String user,
    required CallType type,
    String? category,
  }) {
    return ActiveCallResponse(
      app: "",
      status: CallStatus.calling,
      channel: "",
      name: name,
      type: type,
      user: user,
      category: category ?? "",
      image: "",
      avatar: avatar,
      session: 0,
      isCaller: true,
      error: null,
      errorCode: null,
      snt: "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "app": app,
      "status": status.type,
      "channel": channel,
      "name": name,
      "type": type.type,
      "user": user,
      "category": category,
      "image": image,
      "avatar": avatar,
      "session": session,
      "is_caller": isCaller,
      "error": error,
      "error_code": errorCode,
      "snt": snt,
    };
  }

  Map<String, String> toStringedJson() {
    return {
      "app": app,
      "status": status.type,
      "channel": channel,
      "name": name,
      "type": type.type,
      "user": user,
      "category": category,
      "image": image,
      "avatar": avatar,
      "session": session.toString(),
      "is_caller": isCaller.toString(),
      "error": error ?? "",
      "error_code": errorCode ?? "",
      "snt": snt,
    };
  }

  ActiveCallResponse copyWith({
    String? app,
    CallStatus? status,
    String? channel,
    String? name,
    CallType? type,
    String? user,
    String? category,
    String? image,
    String? avatar,
    int? session,
    bool? isCaller,
    String? error,
    String? errorCode,
    String? snt,
  }) {
    return ActiveCallResponse(
      app: app ?? this.app,
      status: status ?? this.status,
      channel: channel ?? this.channel,
      name: name ?? this.name,
      type: type ?? this.type,
      user: user ?? this.user,
      category: category ?? this.category,
      image: image ?? this.image,
      avatar: avatar ?? this.avatar,
      session: session ?? this.session,
      isCaller: isCaller ?? this.isCaller,
      error: error ?? this.error,
      errorCode: errorCode ?? this.errorCode,
      snt: snt ?? this.snt,
    );
  }

  /// Call is a voice type
  bool get isVoice => type == CallType.voice;

  /// Call is ringing
  bool get isRinging => status == CallStatus.ringing;

  /// Call is calling
  bool get isCalling => status == CallStatus.calling;

  /// Call is on call
  bool get isOnCall => status == CallStatus.onCall;

  /// Call is missed
  bool get isMissed => status == CallStatus.missed;

  /// Call is disconnected
  bool get isDisconnected => status == CallStatus.disconnected;
}