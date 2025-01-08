import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletUpdateBankDetailsLayout extends GetResponsiveView<WalletUpdateBankDetailsController> {
  static String get route => "/centre/wallet/settings/bank";

  WalletUpdateBankDetailsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Payout Bank Details",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText.center(
                text: "Bank name",
                size: Sizing.font(14),
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              Obx(() => FakeField(
                buttonText: "Search",
                searchText: controller.state.bank.value.name.isNotEmpty
                  ? controller.state.bank.value.name
                  : "Bank name (Eg. First Bank of Nigeria)",
                needPadding: false,
                onTap: () => BankListSheet.open(
                  controller: controller,
                  onPick: (bank) => controller.onPick(bank)
                ),
              )),
              const SizedBox(height: 20),
              SText.center(
                text: "Bank number",
                size: Sizing.font(14),
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Field(
                      padding: const EdgeInsets.all(8),
                      labelColor: Theme.of(context).primaryColor,
                      hintText: "Account Number (Eg. 345689345)",
                      keyboard: TextInputType.number,
                      controller: controller.accountNumberController,
                    ),
                  ),
                  Obx(() {
                    if(controller.state.isFetchingBankAccount.value) {
                      return Row(
                        children: [
                          const SizedBox(width: 10),
                          Loading(color: Theme.of(context).primaryColor, size: 20),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  })
                ]
              ),
              const SizedBox(height: 20),
              SText.center(
                text: "Account name",
                size: Sizing.font(14),
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 10),
              Obx(() => FakeField(
                buttonText: "Search",
                searchText: controller.state.account.value.accountName.isNotEmpty
                  ? controller.state.account.value.accountName
                  : "John Doe",
                needPadding: false,
                showSearch: false
              )),
              const SizedBox(height: 50),
              Obx(() => LoadingButton(
                text: "Update",
                borderRadius: 24,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(Sizing.space(12)),
                textSize: Sizing.font(14),
                onClick: controller.updateWallet,
                buttonColor: CommonColors.darkTheme2,
                textColor: CommonColors.lightTheme,
                loading: controller.state.isUpdating.value,
              ))
            ],
          ),
        ),
      ),
    );
  }
}