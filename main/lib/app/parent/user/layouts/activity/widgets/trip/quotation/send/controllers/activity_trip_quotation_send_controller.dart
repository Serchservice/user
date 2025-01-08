import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripQuotationSendController extends GetxController {
  final String trip;
  final int? quotation;
  final Function(TripResponse) onSend;

  ActivityTripQuotationSendController({
    required this.trip,
    this.quotation,
    required this.onSend
  });

  final state = ActivityTripQuotationSendState();

  final TextEditingController amountController = TextEditingController();

  final ConnectService _connect = Connect();

  @override
  void onReady() {
    amountController.addListener(() {
      if(amountController.text.isNotEmpty) {
        state.amount.value = amountController.text;
      }
    });

    super.onReady();
  }

  void send() async {
    state.isSending.value = true;

    var response = await _connect.post(
      endpoint: "/trip/invite/quote",
      body: {
        "quote_id": quotation,
        "id": trip,
        "amount": amountController.text,
        "guest": Database.isUserActive ? "" : Database.guest.id
      }
    );

    state.isSending.value = false;

    if(response.isSuccessful) {
      notify.success(message: response.message);
      onSend.call(TripResponse.fromJson(response.data));
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  @override
  void dispose() {
    amountController.dispose();

    super.dispose();
  }
}