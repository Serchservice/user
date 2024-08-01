import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingController extends GetxController {
  RatingController();
  final state = RatingState();
  final HomeController home = HomeController.data;

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetchRatings();
    super.onInit();
  }

  void fetchRatings() async {
    state.isFetching.value = true;
    var responses = [
      await _connect.get(endpoint: "/rating/all"),
      await _connect.get(endpoint: "/rating/all/good"),
      await _connect.get(endpoint: "/rating/all/bad"),
      await _connect.get(endpoint: "/rating/chart")
    ];

    if(responses.any((response) => !response.isSuccessful)) {
      var response = responses
          .where((response) => !response.isSuccessful)
          .first;
      notify.error(message: response.message);
    } else {
      /// Update recent ratings
      List<dynamic> all = responses[0].data;
      if(all.isEmpty) {
        state.recent.value = [];
      } else {
        final recent = all.map((e) => Rating.fromJson(e)).toList();
        state.recent.value = recent.length > 5 ? recent.sublist(0, 4) : recent.sublist(0, recent.length - 1);
      }

      /// Update good ratings
      List<dynamic> good = responses[1].data;
      if(good.isEmpty) {
        state.goodList.value = [];
      } else {
        final goodList = good.map((e) => Rating.fromJson(e)).toList();
        state.goodList.value = goodList;
      }

      /// Update bad ratings
      List<dynamic> bad = responses[2].data;
      if(bad.isEmpty) {
        state.badList.value = [];
      } else {
        final badList = bad.map((e) => Rating.fromJson(e)).toList();
        state.badList.value = badList;
      }

      /// Update chart
      List<dynamic> chartResult = responses[3].data;
      if(chartResult.isEmpty) {
        state.months.value = [
          Month.getMonths().lastTwoMonths,
          Month.getMonths().lastMonth,
          Month.getMonths().currentMonth
        ];
      } else {
        final chart = chartResult.map((e) => RatingChart.fromJson(e)).toList();
        state.months.value = chart.map((e) => e.month).toList();
        state.bars.value = chart
            .asMap()
            .entries
            .map((e) =>
            getMonthData(
                month: e.key,
                bad: e.value.bad,
                good: e.value.good,
                total: e.value.total,
                average: e.value.average
            )).toList();

        state.current.value = chart.firstWhere((element) {
          return element.month.toLowerCase() == Month
              .getMonths()
              .currentMonth
              .toLowerCase();
        }, orElse: () => RatingChart.current());
      }
      state.isFetching.value = false;
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