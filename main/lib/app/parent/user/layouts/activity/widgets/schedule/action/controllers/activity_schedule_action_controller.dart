import 'package:user/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ActivityScheduleActionController extends GetxController {
  final Schedule schedule;
  final VoidCallback? onScheduleCancelled;
  final VoidCallback? onScheduleStarted;

  ActivityScheduleActionController({required this.schedule, this.onScheduleCancelled, this.onScheduleStarted});
  final state = ActivityScheduleActionState();

  final ConnectService _connect = Connect();

  void cancel() async {
    state.isCancelling.value = true;
    var response = await _connect.patch(endpoint: "/schedule/cancel/${schedule.id}");
    state.isCancelling.value = false;

    if(response.isOk) {
      ActivityRequestedController.data.scheduleController.refresh();
      ActivityHistoryController.data.scheduleController.refresh();

      onScheduleCancelled?.call();
    } else {
      notify.error(message: response.message);
    }
  }

  void start() async {
    state.isStarting.value = true;
    var response = await _connect.patch(endpoint: "/schedule/start/${schedule.id}");
    state.isStarting.value = false;

    if(response.isOk) {
      ActivityRequestedController.data.scheduleController.refresh();
      ActivityActiveController.data.scheduleController.refresh();

      TripResponse trip = TripResponse.fromJson(response.data);
      ActivityActiveController.data.addTrip(trip);

      Navigate.till(ModalRoute.withName(ParentLayout.route));
      ActivityRequestedTripView.open(trip);

      onScheduleStarted?.call();
    } else {
      notify.error(message: response.message);
    }
  }
}