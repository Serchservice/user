import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletController extends GetxController {
  WalletController();
  final state = WalletState();

  final TextEditingController withdrawController = TextEditingController();
  final TextEditingController fundController = TextEditingController();
  final FocusNode focus = FocusNode();

  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  @override
  void onReady() {
    withdrawController.addListener(() {
      if(withdrawController.text.trim().isNotEmpty) {
        state.showWithdrawButton.value = true;
        state.withdrawalAmount.value = withdrawController.text.trim();
      } else {
        state.showWithdrawButton.value = false;
      }
    });

    fundController.addListener(() {
      if(fundController.text.trim().isNotEmpty) {
        state.showFundButton.value = true;
        state.fundingAmount.value = fundController.text.trim();
      } else {
        state.showFundButton.value = false;
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    withdrawController.dispose();
    fundController.dispose();
    super.onClose();
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
    var responses = [
      await _connect.get(endpoint: "/wallet/recent"),
      await _connect.get(endpoint: "/wallet/transactions")
    ];
    if(responses.any((response) => !response.isOk)) {
      notify.error(message: responses.firstWhere((response) => !response.isOk, orElse: () {
        return ApiResponse(status: "", code: 0, message: "An error occurred while fetching your data. Check your network");
      }).message);
    } else {
      List<dynamic> recentResult = responses[0].data;
      List<dynamic> transactionResult = responses[1].data;

      state.recents.value = recentResult.map((result) => TransactionGroup.fromJson(result)).toList();
      state.transactions.value = transactionResult.map((result) => TransactionGroup.fromJson(result)).toList();
      state.isFetching.value = false;
    }
  }

  void fetch() async {
    fetchWallet();
    fetchTransactions();
  }

  void fund() async {
    state.isFunding.value = true;
    var response = await _connect.post(endpoint: "/wallet/fund", body: {
      "amount": fundController.text.trim(),
      // "callback_url": "https://user.serchservice.com/centre/transaction/verify"
    });
    state.isFunding.value = false;
    if(response.isOk) {
      Payment payment = Payment.fromJson(response.data);
      state.payment.value = payment;
      await Navigate.to(WebLayout.route, parameters: {
        "reference": payment.reference,
        "url": payment.authorizationUrl
      });

      verify();
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }

  void verify() async {
    FundWalletSheet.open(controller: this);
    state.isVerifying.value = true;
    var response = await _connect.get(endpoint: "/wallet/fund/verify?reference=${state.payment.value.reference}");
    state.isVerifying.value = false;
    if(response.isOk) {
      Navigate.back();
      fundController.text = "";
      state.fundingAmount.value = "";
      fetch();
    } else {
      notify.error(message: response.message);
      fetch();
    }
  }

  void withdraw() async {
    state.isWithdrawing.value = true;
    var response = await _connect.post(endpoint: "/wallet/withdraw", body: {
      "amount": withdrawController.text.trim()
    });
    state.isWithdrawing.value = false;
    if(response.isOk) {
      Navigate.back();
      withdrawController.text = "";
      state.withdrawalAmount.value = "";
      fetch();
    } else {
      notify.error(message: response.message);
    }
  }
}