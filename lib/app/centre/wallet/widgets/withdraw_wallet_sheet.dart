import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class WithdrawWalletSheet extends StatelessWidget {
  static String get route => "/centre/wallet/withdraw";

  final WalletController controller;
  const WithdrawWalletSheet({super.key, required this.controller});

  static void open({required WalletController controller}) => Navigate.bottomSheet(
    sheet: WithdrawWalletSheet(controller: controller),
    route: "/centre/wallet/withdraw",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
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
          Obx(() {
            if(controller.state.withdrawalAmount.value.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor
                    ),
                    padding: const EdgeInsets.all(8),
                    child: SText(
                      text: CommonUtility.getAmount(controller.state.withdrawalAmount.value),
                      size: Sizing.font(18),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return Container();
            }
          }),
          Field(
            padding: const EdgeInsets.all(8),
            hintText: "Amount",
            keyboard: TextInputType.number,
            controller: controller.withdrawController,
          ),
          const SizedBox(height: 50),
          Obx(() => LoadingButton(
            text: "Withdraw",
            borderRadius: 24,
            padding: EdgeInsets.all(Sizing.space(12)),
            textSize: Sizing.font(11),
            width: MediaQuery.of(context).size.width,
            onClick: controller.withdraw,
            buttonColor: CommonColors.darkTheme2,
            textColor: CommonColors.lightTheme,
            loading: controller.state.isWithdrawing.value,
          ))
        ],
      )
    );
  }
}