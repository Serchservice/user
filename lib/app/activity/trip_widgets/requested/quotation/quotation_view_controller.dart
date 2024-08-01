import 'dart:ui';

import 'package:get/get.dart';
import 'package:user/library.dart';

class QuotationViewController extends GetxController {
  final QuotationResponse quotation;
  final VoidCallback onRemove;
  final Function(TripResponse) onAccept;
  final String trip;

  QuotationViewController({
    required this.quotation,
    required this.onRemove,
    required this.trip,
    required this.onAccept
  });

  final state = QuotationViewState();
  final ConnectService _connect = Connect(useToken: Database.isUserLoggedIn);

  void accept() async {
    state.isAccepting.value = true;
    var response = await _connect.post(
      endpoint: "/trip/invite/accept",
      body: {
        "trip": trip,
        "quote_id": quotation.id,
        "guest": Database.isUserLoggedIn ? "" : Database.guest.id
      }
    );

    state.isAccepting.value = false;
    if(response.isSuccessful) {
      notify.success(message: response.message);
      onAccept.call(TripResponse.fromJson(response.data));
    } else {
      notify.error(message: response.message);
    }
  }

  void decline() async {
    state.isDeclining.value = true;
    var response = await _connect.delete(
      endpoint: "/trip/invite/cancel/quote-${quotation.id}",
      body: {"link_id": Database.isUserLoggedIn ? "" : Database.preference.active}
    );
    state.isDeclining.value = false;

    if(response.isSuccessful) {
      notify.success(message: response.message);
      onRemove.call();
    } else {
      notify.error(message: response.message);
    }
  }
}