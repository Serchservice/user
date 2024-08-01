class Time {
  Time({
    required this.time,
    required this.amTaken,
    required this.pmTaken,
  });

  final String time;
  final bool amTaken;
  final bool pmTaken;

  Time copyWith({
    String? time,
    bool? amTaken,
    bool? pmTaken,
  }) {
    return Time(
      time: time ?? this.time,
      amTaken: amTaken ?? this.amTaken,
      pmTaken: pmTaken ?? this.pmTaken,
    );
  }

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      time: json["time"] ?? "",
      amTaken: json["am_taken"] ?? false,
      pmTaken: json["pm_taken"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "time": time,
    "am_taken": amTaken,
    "pm_taken": pmTaken,
  };
}

/*
{
	"time": "string",
	"am_taken": true,
	"pm_taken": true
}*/