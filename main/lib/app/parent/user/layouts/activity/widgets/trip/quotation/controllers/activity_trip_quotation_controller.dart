import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripQuotationController extends GetxController {
  final QuotationResponse quotation;
  final VoidCallback onRemoved;
  final Function(TripResponse) onAccepted;
  final Function(TripResponse) onUpdated;
  final String trip;

  ActivityTripQuotationController({
    required this.quotation,
    required this.onRemoved,
    required this.trip,
    required this.onAccepted,
    required this.onUpdated
  });

  final state = ActivityTripQuotationState();

  final ConnectService _connect = Connect();

  List<ButtonView> buttons = [
    ButtonView(header: "Accept", color: CommonColors.success, index: 0),
    ButtonView(header: "Send quote", color: CommonColors.allday, index: 1),
    ButtonView(header: "Decline", color: CommonColors.error, index: 2),
  ];

  Widget buildButton(ButtonView view) {
    if(view.index == 1) {
      return LoadingButton(
        text: view.header,
        buttonColor: CommonColors.darkTheme,
        textColor: CommonColors.lightTheme,
        padding: EdgeInsets.zero,
        loading: view.index == 0 ? state.isAccepting.value : view.index == 1 ? false : state.isDeclining.value,
        onClick: () {
          if(view.index == 0) {
            _accept();
          } else if(view.index == 1) {
            ActivityTripQuotationSend.open(trip: trip, quotation: quotation.id, onSend: onUpdated);
          } else {
            _decline();
          }
        }
      );
    } else {
      return Obx(() => LoadingButton(
        text: view.header,
        buttonColor: CommonColors.darkTheme,
        textColor: CommonColors.lightTheme,
        padding: EdgeInsets.zero,
        loading: view.index == 0 ? state.isAccepting.value : view.index == 1 ? false : state.isDeclining.value,
        onClick: () {
          if(view.index == 0) {
            _accept();
          } else if(view.index == 1) {
            ActivityTripQuotationSend.open(trip: trip, quotation: quotation.id, onSend: onUpdated);
          } else {
            _decline();
          }
        }
      ));
    }
  }

  void _accept() async {
    state.isAccepting.value = true;
    var response = await _connect.post(
      endpoint: "/trip/invite/accept",
      body: {
        "trip": trip,
        "quote_id": quotation.id,
        "guest": Database.isUserActive ? "" : Database.guest.id
      }
    );

    state.isAccepting.value = false;
    if(response.isSuccessful) {
      notify.success(message: response.message);
      onAccepted.call(TripResponse.fromJson(response.data));
    } else {
      notify.error(message: response.message);
    }
  }

  void _decline() async {
    state.isDeclining.value = true;
    var response = await _connect.delete(
      endpoint: "/trip/invite/cancel/quote-${quotation.id}",
      body: {"link_id": Database.isUserActive ? "" : Database.preference.active}
    );
    state.isDeclining.value = false;

    if(response.isSuccessful) {
      notify.success(message: response.message);
      onRemoved.call();
    } else {
      notify.error(message: response.message);
    }
  }
}