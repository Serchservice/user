import 'package:user/library.dart';

class CallResponse {
  CallResponse({
    required this.member,
    required this.history,
  });

  final CallMember member;
  final List<CallHistory> history;

  CallResponse copyWith({
    CallMember? member,
    List<CallHistory>? history,
  }) {
    return CallResponse(
      member: member ?? this.member,
      history: history ?? this.history,
    );
  }

  factory CallResponse.fromJson(Map<String, dynamic> json) {
    return CallResponse(
      member: CallMember.fromJson(json["member"]),
      history: json["history"] == null
          ? []
          : List<CallHistory>.from(json["history"]!.map((x) => CallHistory.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "member": member.toJson(),
    "history": history.map((x) => x.toJson()).toList(),
  };

  factory CallResponse.empty() {
    return CallResponse.fromJson({
      "member": {
        "member": "",
        "name": "",
        "avatar": "",
        "category": ""
      },
      "history": []
    });
  }
}

/*
{
	"member": {
		"member": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
		"name": "string",
		"avatar": "string",
		"category": "MECHANIC"
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