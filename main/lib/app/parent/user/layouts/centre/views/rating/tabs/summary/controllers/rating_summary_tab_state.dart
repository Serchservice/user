import 'package:user/library.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RatingSummaryTabState {
  /// Show rating information
  RxBool showRating = RxBool(Database.notifier.showRating);

  /// Is fetching rating
  RxBool isFetching = RxBool(true);

  /// Fetching for first time
  RxBool isFirstTimeFetch = RxBool(true);

  /// Has error
  RxBool hasFetchError = RxBool(false);

  /// Rating chart
  Rx<RatingChart> current = RatingChart.current().obs;

  /// Rating chart months
  RxList<String> months = <String>[].obs;

  /// Bar Group List Data
  RxList<BarChartGroupData> bars = <BarChartGroupData>[].obs;
}