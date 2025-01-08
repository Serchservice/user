import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityHistoryTripViewController extends GetxController {
  final TripResponse trip;
  ActivityHistoryTripViewController({required this.trip});

  final state = ActivityHistoryTripViewState();

  @override
  void onInit() {
    state.trip.value = trip;

    super.onInit();
  }
}