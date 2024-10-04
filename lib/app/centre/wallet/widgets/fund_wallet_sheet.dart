import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class FundWalletSheet extends StatelessWidget {
  static String get route => "/centre/wallet/fund";

  final WalletController controller;
  const FundWalletSheet({super.key, required this.controller});

  static void open({required WalletController controller}) => Navigate.bottomSheet(
    sheet: FundWalletSheet(controller: controller),
    route: "/centre/wallet/fund",
    isScrollable: true
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Obx(() {
            if(controller.state.isVerifying.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loading(
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                      const SizedBox(height: 6),
                      SText(
                        text: "Verifying...",
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SText(
                      text: "Enter amount you want to fund with",
                      size: Sizing.font(16),
                      weight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(controller.state.fundingAmount.value.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).scaffoldBackgroundColor
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Obx(() => SText(
                        text: CommonUtility.getAmount(controller.state.fundingAmount.value),
                        size: Sizing.font(18),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ))
                    ),
                    const SizedBox(height: 20),
                  ],
                  Field(
                    padding: const EdgeInsets.all(8),
                    hintText: "Amount",
                    keyboard: TextInputType.number,
                    controller: controller.fundController,
                  ),
                  const SizedBox(height: 50),
                  LoadingButton(
                    text: "Fund",
                    borderRadius: 24,
                    padding: EdgeInsets.all(Sizing.space(12)),
                    textSize: Sizing.font(14),
                    width: MediaQuery.sizeOf(context).width,
                    onClick: controller.fund,
                    buttonColor: CommonColors.darkTheme2,
                    textColor: CommonColors.lightTheme,
                    loading: controller.state.isFunding.value,
                  )
                ],
              );
            }
          })
        ],
      )
    );
  }
}