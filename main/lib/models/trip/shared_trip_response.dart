import 'package:user/library.dart';

class SharedTripResponse {
  SharedTripResponse({
    required this.id,
    required this.category,
    required this.profile,
    required this.timelines,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.cancelReason,
    required this.authentication,
    required this.status,
    required this.showCancel,
    required this.showAuth,
    required this.showEnd,
    required this.showShare,
    required this.showGrant,
    required this.showDeny,
    required this.showLeave,
    required this.location,
  });

  final int id;
  final String category;
  final UserResponse? profile;
  final List<TimelineResponse> timelines;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String cancelReason;
  final String authentication;
  final String status;
  final bool showCancel;
  final bool showAuth;
  final bool showEnd;
  final bool showShare;
  final bool showGrant;
  final bool showDeny;
  final bool showLeave;
  final MapViewResponse location;

  SharedTripResponse copyWith({
    int? id,
    String? category,
    UserResponse? profile,
    List<TimelineResponse>? timelines,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? cancelReason,
    String? authentication,
    String? status,
    bool? showCancel,
    bool? showAuth,
    bool? showEnd,
    bool? showShare,
    bool? showGrant,
    bool? showDeny,
    bool? showLeave,
    MapViewResponse? location,
  }) {
    return SharedTripResponse(
      id: id ?? this.id,
      category: category ?? this.category,
      profile: profile ?? this.profile,
      timelines: timelines ?? this.timelines,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cancelReason: cancelReason ?? this.cancelReason,
      authentication: authentication ?? this.authentication,
      status: status ?? this.status,
      showCancel: showCancel ?? this.showCancel,
      showAuth: showAuth ?? this.showAuth,
      showEnd: showEnd ?? this.showEnd,
      showShare: showShare ?? this.showShare,
      showGrant: showGrant ?? this.showGrant,
      showDeny: showDeny ?? this.showDeny,
      showLeave: showLeave ?? this.showLeave,
      location: location ?? this.location,
    );
  }

  factory SharedTripResponse.fromJson(Map<String, dynamic> json){
    return SharedTripResponse(
      id: json["id"] ?? 0,
      category: json["category"] ?? "",
      profile: json["profile"] == null ? null : UserResponse.fromJson(json["profile"]),
      timelines: json["timelines"] == null? [] : List<TimelineResponse>.from(json["timelines"]!.map((x) => TimelineResponse.fromJson(x))),
      phoneNumber: json["phone_number"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      cancelReason: json["cancel_reason"] ?? "",
      authentication: json["authentication"] ?? "",
      status: json["status"] ?? "",
      showCancel: json["show_cancel"] ?? false,
      showAuth: json["show_auth"] ?? false,
      showEnd: json["show_end"] ?? false,
      showShare: json["show_share"] ?? false,
      showGrant: json["show_grant"] ?? false,
      showDeny: json["show_deny"] ?? false,
      showLeave: json["show_leave"] ?? false,
      location: json["location"] == null ? MapViewResponse.empty() : MapViewResponse.fromJson(json["location"])
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "profile": profile?.toJson(),
    "timelines": timelines.map((x) => x.toJson()).toList(),
    "phone_number": phoneNumber,
    "first_name": firstName,
    "last_name": lastName,
    "cancel_reason": cancelReason,
    "authentication": authentication,
    "status": status,
    "show_cancel": showCancel,
    "show_auth": showAuth,
    "show_end": showEnd,
    "show_share": showShare,
    "show_grant": showGrant,
    "show_deny": showDeny,
    "show_leave": showLeave,
    "location": location.toJson(),
  };

  bool get isWaiting => status == "WAITING";
  bool get isClosed => status == "CLOSED";
  bool get isUnfulfilled => status == "UNFULFILLED";
  bool get isActive => status == "ACTIVE";

  bool get isOffline => profile != null && profile!.role.contains("Offline");
}