import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class UpdateBankDetailsController extends GetxController {
  UpdateBankDetailsController();
  final state = UpdateBankDetailsState();

  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankSearch = TextEditingController();

  final FocusNode focus = FocusNode();

  final WalletController _walletController = Get.find<WalletController>();
  final ConnectService _connect = Connect();

  @override
  void onInit() {
    fetchBanks();
    super.onInit();
  }

  @override
  void onReady() {
    accountNumberController.text = _walletController.state.wallet.value.accountNumber;

    accountNumberController.addListener(() {
      if(accountNumberController.text.isNotEmpty && accountNumberController.text != _walletController.state.wallet.value.accountNumber) {
        if(accountNumberController.text.length == 10) {
          validateBankAccount();
        }
      }
    });

    bankSearch.addListener(() {
      if(bankSearch.text.isNotEmpty) {
        List<Bank> banks = List.from(state.banks);
        state.filteredBanks.value = banks.where((bank) {
          return bank.name.toLowerCase().contains(bankSearch.text.toLowerCase())
              || bank.code.toLowerCase().contains(bankSearch.text.toLowerCase());
        }).toList();
      }
    });

    state.bank.value = Bank(name: _walletController.state.wallet.value.bankName, code: "");
    state.account.value = BankAccount(
      accountNumber: _walletController.state.wallet.value.accountNumber,
      accountName: _walletController.state.wallet.value.accountName
    );
    super.onReady();
  }

  @override
  void onClose() {
    accountNumberController.dispose();
    bankSearch.dispose();
    super.onClose();
  }

  void onPick(Bank bank) {
    state.bank.value = bank;
    Navigate.back();
  }

  void fetchBanks() async {
    state.isLoadingBanks.value = true;
    var response = await _connect.get(endpoint: "/banking/banks");
    state.isLoadingBanks.value = false;
    if(response.isOk) {
      List<dynamic> list = response.data;
      state.banks.value = Bank.list(list);
    }
  }

  void validateBankAccount() async {
    state.isFetchingBankAccount.value = true;
    var response = await _connect.get(
      endpoint: "/banking/verify?number=${accountNumberController.text.trim()}&code=${state.bank.value.code}"
    );
    state.isFetchingBankAccount.value = false;
    if(response.isOk) {
      BankAccount account = BankAccount.fromJson(response.data);
      state.account.value = account;
    } else {
      notify.error(message: response.message);
    }
  }

  void updateWallet() async {
    state.isUpdating.value = true;
    var response = await _connect.post(endpoint: "/wallet/update", body: {
      "account_number": accountNumberController.text.trim(),
      "account_name": state.account.value.accountName,
      "bank_name": state.bank.value.name,
    });
    state.isUpdating.value = false;
    if(response.isOk) {
      _walletController.fetchWallet();
      Navigate.back();
    } else {
      notify.error(message: response.message);
    }
  }
}