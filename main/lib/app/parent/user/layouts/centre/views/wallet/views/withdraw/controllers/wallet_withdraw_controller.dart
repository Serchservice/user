import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletWithdrawController extends GetxController {
  WalletWithdrawController();
  final state = WalletWithdrawState();

  final ConnectService _connect = Connect();

  final TextEditingController inputController = TextEditingController();
  final FocusNode focus = FocusNode();

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

  void withdraw() async {
    state.isSending.value = true;
    var response = await _connect.post(endpoint: "/wallet/withdraw", body: {
      "amount": inputController.text.trim()
    });
    state.isSending.value = false;

    if(response.isOk) {
      WalletController.data.fetch();

      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }
}