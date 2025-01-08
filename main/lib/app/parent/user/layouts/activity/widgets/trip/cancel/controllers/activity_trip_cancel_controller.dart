import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripCancelController extends GetxController {
  final String trip;
  final bool isShared;
  final bool isInvite;
  final Function(List<TripResponse>, bool) onSuccess;

  ActivityTripCancelController({
    required this.trip,
    required this.isShared,
    required this.onSuccess,
    required this.isInvite
  });
  final state = ActivityTripCancelState();

  final ConnectService _connect = Connect();
  final TextEditingController textController = TextEditingController();

  void cancel() async {
    state.isCancelling.value = true;
    if(isShared) {
      var response = await _connect.delete(
        endpoint: "/trip/shared/cancel",
        body: {
          "trip": trip,
          "reason": textController.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );

      state.isCancelling.value = false;

      if(response.isSuccessful) {
        notify.success(message: response.message);
        onSuccess.call([], false);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
    } else if(isInvite) {
      var response = await _connect.delete(
        endpoint: "/trip/invite/cancel",
        body: {
          "trip": trip,
          "reason": textController.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );
      state.isCancelling.value = false;

      if(response.isSuccessful) {
        notify.success(message: response.message);
        onSuccess.call([], true);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
    } else {
      var response = await _connect.patch(
        endpoint: "/trip/cancel",
        body: {
          "trip": trip,
          "reason": textController.text,
          "guest": Database.isUserActive ? "" : Database.guest.id,
          "link_id": Database.isUserActive ? "" : Database.preference.active
        }
      );
      state.isCancelling.value = false;

      if(response.isSuccessful) {
        notify.success(message: response.message);
        List<dynamic> data = response.data;
        onSuccess.call(data.map((d) => TripResponse.fromJson(d)).toList(), true);
        Navigate.back();
      } else {
        notify.error(message: response.message);
      }
    }
  }

  @override
  void onClose() {
    textController.dispose();

    super.onClose();
  }
}