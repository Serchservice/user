import 'package:user/library.dart';

class CallResponse {
  CallResponse({
    required this.member,
    required this.recent,
    required this.history,
  });

  final CallMember member;
  final CallHistory recent;
  final List<CallHistory> history;

  CallResponse copyWith({
    CallMember? member,
    CallHistory? recent,
    List<CallHistory>? history,
  }) {
    return CallResponse(
      member: member ?? this.member,
      recent: recent ?? this.recent,
      history: history ?? this.history,
    );
  }

  factory CallResponse.fromJson(Map<String, dynamic> json) {
    return CallResponse(
      member: CallMember.fromJson(json["member"]),
      recent: CallHistory.fromJson(json["recent"]),
      history: json["history"] == null
        ? []
        : List<CallHistory>.from(json["history"]!.map((x) => CallHistory.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "member": member.toJson(),
    "recent": recent.toJson(),
    "history": history.map((x) => x.toJson()).toList(),
  };
}

/*
{
	"member": {
		"member": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
		"name": "string",
		"avatar": "string",
		"category": "MECHANIC"
	},
	"recent": {
		"label": "string",
		"duration": "string",
		"outgoing": true,
		"type": "VOICE",
		"status": "CALLING"
	},
	"history": [
		{
			"label": "string",
			"duration": "string",
			"outgoing": true,
			"type": "VOICE",
			"status": "CALLING"
		}
	]
}*/