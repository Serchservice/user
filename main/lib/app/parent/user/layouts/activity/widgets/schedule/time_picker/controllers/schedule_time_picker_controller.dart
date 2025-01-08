import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ScheduleTimePickerController extends GetxController {
  final String id;
  final BuildContext context;
  final Function(Schedule) onSchedule;

  ScheduleTimePickerController({required this.id, required this.context, required this.onSchedule});
  final state = ScheduleTimePickerState();

  final TextEditingController amount = TextEditingController();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    getTimes();
    super.onInit();
  }

  @override
  void onReady() {
    amount.addListener(() {
      if(amount.text.trim().isNotEmpty) {
        state.amount.value = amount.text.trim();
      }
    });
    super.onReady();
  }

  void getTimes() async {
    state.isFetchingTimes.value = true;
    var response = await _connect.get(endpoint: "/schedule/all/times/$id");
    if(response.isOk) {
      List<dynamic> result = response.data;
      List<Time> times = result.map((data) => Time.fromJson(data)).toList();
      state.times.value = times;
      state.isFetchingTimes.value = false;
    } else {
      notify.tip(message: response.message);
    }
  }

  void schedule() async {
    if(state.location.value.latitude == 0.0) {
      notify.error(message: "Your location is needed to proceed");
      return;
    }

    if(amount.text.isEmpty || amount.text == "0" || amount.text == "0.0") {
      notify.error(message: "Trip amount is needed to proceed");
      return;
    }

    state.isScheduling.value = true;
    var response = await _connect.post(endpoint: "/schedule", body: {
      "provider": id,
      "time": "${state.selected.value.time}${state.part.value}".toUpperCase(),
      "amount": amount.text.trim(),
      "address": state.location.value.place,
      "latitude": state.location.value.latitude,
      "longitude": state.location.value.longitude,
      "place_id": state.location.value.id,
    });
    state.isScheduling.value = false;

    if(response.isOk) {
      ActivityRequestedController.data.scheduleController.refresh();

      onSchedule.call(Schedule.fromJson(response.data));
      Navigate.back();
    } else {
      notify.tip(message: response.message);
    }
  }

  @override
  void onClose() {
    amount.dispose();

    super.onClose();
  }
}