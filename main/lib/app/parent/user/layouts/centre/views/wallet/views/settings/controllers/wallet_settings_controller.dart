import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletSettingsController extends GetxController {
  WalletSettingsController();
  final state = WalletSettingsState();

  final TextEditingController payoutController = TextEditingController();
  final TextEditingController paydayController = TextEditingController();
  final FocusNode focus = FocusNode();

  final WalletController walletController = Get.find<WalletController>();
  final ConnectService _connect = Connect();

  @override
  void onReady() {
    payoutController.addListener(() {
      if(payoutController.text.trim().isNotEmpty) {
        state.showUpdateButton.value = true;
      } else {
        state.showUpdateButton.value = false;
      }
    });

    state.shouldPayoutOnPayday.value = walletController.state.wallet.value.payoutOnPayday;

    paydayController.addListener(() {
      if(paydayController.text.trim().isNotEmpty) {
        state.showUpdateButton.value = true;
      } else {
        state.showUpdateButton.value = false;
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    paydayController.dispose();
    payoutController.dispose();
    super.onClose();
  }

  void updateWallet() async {
    state.isUpdating.value = true;
    var response = await _connect.post(endpoint: "/wallet/update", body: {
      "payday": paydayController.text.trim(),
      "payout": payoutController.text.trim(),
      "payout_on_payday": state.shouldPayoutOnPayday.value
    });
    state.isUpdating.value = false;
    if(response.isOk) {
      walletController.fetchWallet();
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  String payout(String payout) {
    return payout.substring(1, payout.indexOf("."));
  }
}