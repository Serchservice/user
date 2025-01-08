import 'package:user/library.dart';

class RatingChart {
  RatingChart({
    required this.month,
    required this.average,
    required this.total,
    required this.bad,
    required this.good,
  });

  final String month;
  final double average;
  final double total;
  final double bad;
  final double good;

  RatingChart copyWith({
    String? month,
    double? average,
    double? total,
    double? bad,
    double? good,
  }) {
    return RatingChart(
      month: month ?? this.month,
      average: average ?? this.average,
      total: total ?? this.total,
      bad: bad ?? this.bad,
      good: good ?? this.good,
    );
  }

  factory RatingChart.fromJson(Map<String, dynamic> json) {
    return RatingChart(
      month: json["month"] ?? "",
      average: json["average"] ?? 0,
      total: json["total"] ?? 0,
      bad: json["bad"] ?? 0,
      good: json["good"] ?? 0,
    );
  }

  factory RatingChart.current() {
    return RatingChart(
      month: Month.getCurrentMonth(),
      average: 0,
      total: 0,
      bad: 0,
      good: 0
    );
  }

  Map<String, dynamic> toJson() => {
    "month": month,
    "average": average,
    "total": total,
    "bad": bad,
    "good": good,
  };
}

/*
{
	"month": "string",
	"average": 0,
	"total": 0,
	"bad": 0,
	"good": 0
}*/