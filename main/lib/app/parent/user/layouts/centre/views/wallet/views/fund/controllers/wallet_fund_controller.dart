import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletFundController extends GetxController {
  final String reference;

  WalletFundController({this.reference = ""});
  final state = WalletFundState();

  final ConnectService _connect = Connect();

  final TextEditingController inputController = TextEditingController();
  final FocusNode focus = FocusNode();

  @override
  void onInit() {
    if(reference.isNotEmpty) {
      _verifyRequest(reference);
    }

    super.onInit();
  }

  void fund() async {
    state.isSending.value = true;
    var response = await _connect.post(endpoint: "/wallet/fund", body: {
      "amount": inputController.text.trim(),
      // "callback_url": "https://user.serchservice.com/centre/transaction/verify"
    });

    state.isSending.value = false;
    if(response.isOk) {
      Payment payment = Payment.fromJson(response.data);
      WalletController.data.state.reference.value = payment.reference;

      await Navigate.to(WebLayout.route, parameters: {
        "reference": payment.reference,
        "url": payment.authorizationUrl
      });

      _verifyRequest(payment.reference);
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  void _verifyRequest(String reference) async {
    state.isVerifying.value = true;
    var response = await _connect.get(endpoint: "/wallet/fund/verify?reference=$reference");
    state.isVerifying.value = false;

    if(response.isOk) {
      WalletController.data.state.reference.value = "";
      WalletController.data.fetch();

      Navigate.back();
    } else {
      WalletController.data.fetch();

      notify.error(message: response.message);
    }
  }

  @override
  void onReady() {
    inputController.addListener(() {
      if(inputController.text.trim().isNotEmpty) {
        state.showButton.value = true;
        state.amount.value = inputController.text.trim();
      } else {
        state.showButton.value = false;
      }
    });

    super.onReady();
  }

  @override
  void onClose() {
    inputController.dispose();

    super.onClose();
  }
}