import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletController extends GetxController {
  WalletController();
  static WalletController get data => Get.find<WalletController>();

  final state = WalletState();

  final ConnectService _connect = Connect();

  List<ButtonView> tabs = [
    ButtonView(header: "Fund", icon: Icons.add_rounded),
    ButtonView(header: "Withdraw", icon: Icons.send_rounded),
    ButtonView(header: "View info", icon: Icons.wallet_rounded),
    ButtonView(header: "History", icon: Icons.history_rounded),
  ];

  @override
  void onInit() {
    fetch();

    super.onInit();
  }

  void fetch() async {
    fetchWallet();
    fetchTransactions();
  }

  void fetchWallet() async {
    state.isFetchingWallet.value = true;
    var response = await _connect.get(endpoint: "/wallet");
    if(response.isSuccessful) {
      Wallet wallet = Wallet.fromJson(response.data);
      state.wallet.value = wallet;
      state.isFetchingWallet.value = false;
    }
  }

  void fetchTransactions() async {
    state.isFetching.value = true;
    var response = await _connect.get(endpoint: "/wallet/recent");

    state.isFetching.value = false;
    if(response.isSuccessful) {
      List<dynamic> result = response.data;
      state.recentList.value = result.map((i) => TransactionGroup.fromJson(i)).toList();
    } else {
      notify.error(message: response.message);
    }
  }
}