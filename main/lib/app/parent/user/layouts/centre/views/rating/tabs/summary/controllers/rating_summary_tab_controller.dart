import 'dart:ui';

import 'package:user/library.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class RatingSummaryTabController extends GetxController {
  RatingSummaryTabController();
  final state = RatingSummaryTabState();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetch(true);

    super.onInit();
  }

  void fetch(bool withError) async {
    if(state.isFetching.value && !state.hasFetchError.value && !state.isFirstTimeFetch.value) {
      return;
    }

    state.isFetching.value = true;

    var response = await _connect.get(endpoint: "/rating/chart");

    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      List<RatingChart> charts = result.map((e) => RatingChart.fromJson(e)).toList();

      if(charts.isEmpty) {
        state.months.value = [
          Month.getMonths().lastTwoMonths,
          Month.getMonths().lastMonth,
          Month.getMonths().currentMonth
        ];
      } else {
        state.months.value = charts.map((e) => e.month).toList();
        state.bars.value = charts.asMap().entries.map((e) => getMonthData(
          month: e.key,
          bad: e.value.bad,
          good: e.value.good,
          total: e.value.total,
          average: e.value.average
        )).toList();

        state.current.value = charts.firstWhere((element) {
          return element.month.toLowerCase() == Month.getMonths().currentMonth.toLowerCase();
        }, orElse: () => RatingChart.current());
      }

      state.isFetching.value = false;
      state.hasFetchError.value = false;
      state.isFirstTimeFetch.value = false;
    } else {
      if(withError) {
        notify.error(message: response.message);
      }

      state.isFirstTimeFetch.value = false;
      state.hasFetchError.value = true;
    }
  }

  BarChartGroupData getMonthData({
    required int month, required double bad,
    required double good, required double average,
    required double total
  }) {
    return BarChartGroupData(
      barsSpace: 5,
      x: month,
      barRods: [
        BarChartRodData(
          toY: bad,
          color: CommonColors.error,
          width: 7,
        ),
        BarChartRodData(
          toY: good,
          color: CommonColors.success,
          width: 7,
        ),
        BarChartRodData(
          toY: average,
          color: const Color(0xFFFF3AF2),
          width: 7,
        ),
        BarChartRodData(
          toY: total,
          color: CommonColors.freePlan,
          width: 7,
        ),
      ],
    );
  }

  void stopShowingRating() {
    Database.saveNotifier(Database.notifier.copyWith(showRating: false));
    state.showRating.value = false;
  }
}