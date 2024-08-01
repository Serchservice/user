import 'package:user/library.dart';

class ScheduleGroup {
  ScheduleGroup({
    required this.label,
    required this.time,
    required this.schedules,
  });

  final String label;
  final DateTime? time;
  final List<Schedule> schedules;

  ScheduleGroup copyWith({
    String? label,
    DateTime? time,
    List<Schedule>? schedules,
  }) {
    return ScheduleGroup(
      label: label ?? this.label,
      time: time ?? this.time,
      schedules: schedules ?? this.schedules,
    );
  }

  factory ScheduleGroup.fromJson(Map<String, dynamic> json) {
    return ScheduleGroup(
      label: json["label"] ?? "",
      time: DateTime.tryParse(json["time"] ?? ""),
      schedules: json["schedules"] == null
        ? []
        : List<Schedule>.from(json["schedules"]!.map((x) => Schedule.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "label": label,
    "time": time?.toIso8601String(),
    "schedules": schedules.map((x) => x.toJson()).toList(),
  };
}
