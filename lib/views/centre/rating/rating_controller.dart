import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingController extends GetxController {
  RatingController();
  final state = RatingState();
  final HomeController home = Get.find<HomeController>();

  final Connect _connect = Connect();

  @override
  void onInit() {
    fetchRatings();
    super.onInit();
  }

  void fetchRatings() async {
    state.isFetching.value = true;
    try {
      var allRes = await _connect.get(endpoint: "/rating/all");
      ApiResponse allResponse = ApiResponse.fromJson(allRes.data);

      var goodRes = await _connect.get(endpoint: "/rating/all/good");
      ApiResponse goodResponse = ApiResponse.fromJson(goodRes.data);

      var badRes = await _connect.get(endpoint: "/rating/all/bad");
      ApiResponse badResponse = ApiResponse.fromJson(badRes.data);

      var chartRes = await _connect.get(endpoint: "/rating/chart");
      ApiResponse chartResponse = ApiResponse.fromJson(chartRes.data);

      if(allResponse.isOk && goodResponse.isOk && badResponse.isOk && chartResponse.isOk) {
        /// Update recent ratings
        List<dynamic> allResult = allResponse.data;
        if(allResult.isEmpty) {
          state.recent.value = [];
        } else {
          final recent = allResult.map((e) => Rating.fromJson(e)).toList();
          state.recent.value = recent.length > 5 ? recent.sublist(0, 4) : recent.sublist(0, recent.length - 1);
        }

        /// Update good ratings
        List<dynamic> goodResult = goodResponse.data;
        if(goodResult.isEmpty) {
          state.goodList.value = [];
        } else {
          final goodList = goodResult.map((e) => Rating.fromJson(e)).toList();
          state.goodList.value = goodList;
        }

        /// Update bad ratings
        List<dynamic> badResult = badResponse.data;
        if(badResult.isEmpty) {
          state.badList.value = [];
        } else {
          final badList = badResult.map((e) => Rating.fromJson(e)).toList();
          state.badList.value = badList;
        }

        /// Update chart
        List<dynamic> chartResult = chartResponse.data;
        if(chartResult.isEmpty) {
          state.months.value = [
            Month.getMonths().lastTwoMonths,
            Month.getMonths().lastMonth,
            Month.getMonths().currentMonth
          ];
        } else {
          final chart = chartResult.map((e) => RatingChart.fromJson(e)).toList();
          state.months.value = chart.map((e) => e.month).toList();
          state.bars.value = chart.asMap().entries.map((e) => getMonthData(
            month: e.key,
            bad: e.value.bad,
            good: e.value.good,
            total: e.value.total,
            average: e.value.average
          )).toList();

          state.current.value = chart.firstWhere((element) {
            return element.month.toLowerCase() == Month.getMonths().currentMonth.toLowerCase();
          }, orElse: () => RatingChart.current());
        }
        state.isFetching.value = false;
        return;
      } else {
        if(allResponse.isOk) {
          if(goodResponse.isOk) {
            if(badResponse.isOk) {
              SnackBars.top(message: chartResponse.message, type: Snackbar.error);
              return;
            } else {
              SnackBars.top(message: badResponse.message, type: Snackbar.error);
              return;
            }
          } else {
            SnackBars.top(message: goodResponse.message, type: Snackbar.error);
            return;
          }
        } else {
          SnackBars.top(message: allResponse.message, type: Snackbar.error);
          return;
        }
      }
    } on Exception catch (e) {
      Connect.showError(e);
      return;
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