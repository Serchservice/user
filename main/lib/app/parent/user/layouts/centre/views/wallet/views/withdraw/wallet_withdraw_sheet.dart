import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class WalletWithdrawSheet extends StatelessWidget {
  static String get route => "/centre/wallet/withdraw";

  const WalletWithdrawSheet({super.key});

  static void open() => Navigate.bottomSheet(
    sheet: WalletWithdrawSheet(),
    route: "/centre/wallet/withdraw",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return GetX<WalletWithdrawController>(
      init: WalletWithdrawController(),
      builder: (controller) {
        bool showButton = controller.state.showButton.value;

        return CurvedBottomSheet(
          safeArea: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(2)),
                margin: EdgeInsets.all(Sizing.space(6)),
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(16)
                ),
              ),
              SText(
                text: "Enter amount you want to withdraw",
                size: Sizing.font(16),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 20),
              if(controller.state.amount.value.isNotEmpty) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                      padding: const EdgeInsets.all(8),
                      child: SText(
                        text: CommonUtility.getAmount(controller.state.amount.value),
                        size: Sizing.font(18),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                    const SizedBox(height: 20),
                  ],
                )
              ],
              Field(
                padding: const EdgeInsets.all(8),
                hintText: "Amount",
                keyboard: TextInputType.number,
                focus: controller.focus,
                controller: controller.inputController,
              ),
              const SizedBox(height: 50),
              if(showButton) ...[
                LoadingButton(
                  text: "Withdraw",
                  borderRadius: 24,
                  padding: EdgeInsets.all(Sizing.space(12)),
                  textSize: Sizing.font(14),
                  width: MediaQuery.sizeOf(context).width,
                  onClick: controller.withdraw,
                  buttonColor: CommonColors.darkTheme2,
                  textColor: CommonColors.lightTheme,
                  loading: controller.state.isSending.value,
                )
              ]
            ],
          )
        );
      },
    );
  }
}