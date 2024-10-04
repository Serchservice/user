import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletSettingsLayout extends GetResponsiveView<WalletSettingsController> {
  static String get route => "/centre/wallet/settings";

  WalletSettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Wallet Information",
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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: CommonColors.darkTheme2,
                  child: InkWell(
                    onTap: () => Navigate.to(UpdateBankDetailsLayout.route),
                    child: Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: "Bank",
                            size: Sizing.font(14),
                            color: CommonColors.hint
                          ),
                          const SizedBox(height: 5),
                          Obx(() => SText(
                            text: controller.walletController.state.wallet.value.bankName,
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: CommonColors.lightTheme
                          )),
                          const SizedBox(height: 10),
                          SText(
                            text: "Account Number",
                            size: Sizing.font(14),
                            color: CommonColors.hint
                          ),
                          const SizedBox(height: 5),
                          Obx(() => SText(
                            text: controller.walletController.state.wallet.value.accountNumber,
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: CommonColors.lightTheme
                          )),
                          const SizedBox(height: 10),
                          SText(
                            text: "Account Name",
                            size: Sizing.font(14),
                            color: CommonColors.hint
                          ),
                          const SizedBox(height: 5),
                          Obx(() => SText(
                            text: controller.walletController.state.wallet.value.accountName,
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: CommonColors.lightTheme
                          )),
                          const SizedBox(height: 10),
                          SText(
                            text: "Payout Amount",
                            size: Sizing.font(14),
                            color: CommonColors.hint
                          ),
                          const SizedBox(height: 5),
                          Obx(() => SText(
                            text: CommonUtility.getAmount(controller.walletController.state.wallet.value.payout),
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: CommonColors.lightTheme
                          )),
                          const SizedBox(height: 10),
                          SText(
                            text: "Payout every ${controller.walletController.state.wallet.value.payday} day/s",
                            size: Sizing.font(14),
                            color: CommonColors.hint
                          ),
                          const SizedBox(height: 10),
                          if(controller.walletController.state.wallet.value.nextPayday.isNotEmpty) ...[
                            SText(
                              text: "Next payday is ${controller.walletController.state.wallet.value.nextPayday}",
                              size: Sizing.font(14),
                              color: CommonColors.hint
                            ),
                            const SizedBox(height: 10),
                          ],
                          Center(
                            child: SText(
                              text: "Tap to edit",
                              size: Sizing.font(12),
                              color: CommonColors.hint
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              SText(
                text: "Payout Settings",
                color: Theme.of(context).primaryColor,
                size: Sizing.font(14),
                weight: FontWeight.bold
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SText(
                    text: "Automate payout for me every",
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColor
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Field(
                      padding: const EdgeInsets.all(8),
                      labelColor: Theme.of(context).primaryColor,
                      hintText: "2000",
                      keyboard: TextInputType.number,
                      controller: controller.paydayController,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SText(
                    text: "day/s",
                    size: Sizing.font(14),
                    color: Theme.of(context).primaryColorLight
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Field(
                padding: const EdgeInsets.all(8),
                labelColor: Theme.of(context).primaryColor,
                hintText: "Payout - Amount you get on paydays (Eg. 5,000)",
                keyboard: TextInputType.number,
                controller: controller.payoutController,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SText(
                          text: "Payout on payday",
                          size: Sizing.font(15),
                          color: Theme.of(context).primaryColor
                        ),
                        SText(
                          text: "Automate payout for me when it's my payday",
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ],
                    )
                  ),
                  const SizedBox(width: 20),
                  Obx(() => Switcher(
                    onChanged: (value) {
                      controller.state.shouldPayoutOnPayday.value = value;
                      controller.state.showUpdateButton.value = true;
                    },
                    value: controller.state.shouldPayoutOnPayday.value
                  ))
                ],
              ),
              const SizedBox(height: 30),
              Obx(() {
                if(controller.state.showUpdateButton.value) {
                  return LoadingButton(
                    text: "Update",
                    borderRadius: 24,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(Sizing.space(12)),
                    textSize: Sizing.font(14),
                    onClick: controller.updateWallet,
                    buttonColor: CommonColors.darkTheme2,
                    textColor: CommonColors.lightTheme,
                    loading: controller.state.isUpdating.value,
                  );
                } else {
                  return Container();
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}