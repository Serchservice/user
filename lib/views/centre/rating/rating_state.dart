import 'package:get/state_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:user/library.dart';

class RatingState {
  /// Is fetching rating
  RxBool isFetching = RxBool(true);

  /// Show rating information
  RxBool showRating = RxBool(Database.notifier.showRating);

  /// List of good ratings
  RxList<Rating> goodList = <Rating>[].obs;

  /// List of bad ratings
  RxList<Rating> badList = <Rating>[].obs;

  /// List of recent ratings
  RxList<Rating> recent = <Rating>[].obs;

  /// Rating chart
  Rx<RatingChart> current = RatingChart.current().obs;

  /// Rating chart months
  RxList<String> months = <String>[].obs;

  /// Bar Group List Data
  RxList<BarChartGroupData> bars = <BarChartGroupData>[].obs;
}