import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class BankListSheet extends StatelessWidget {
  final WalletUpdateBankDetailsController controller;
  final Function(Bank) onPick;
  const BankListSheet({super.key, required this.controller, required this.onPick});

  static void open({required WalletUpdateBankDetailsController controller, required Function(Bank) onPick}) {
    Navigate.bottomSheet(
      sheet: BankListSheet(controller: controller, onPick: onPick),
      route: "/centre/wallet/update_bank_details",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: SingleChildScrollView(
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
              if(controller.state.isLoadingBanks.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Loading(
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                );
              } else if(controller.state.banks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: SText(
                            text: "An error occurred while fetching banks. Try again",
                            size: Sizing.font(16),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                        const SizedBox(height: 50),
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
                        text: "Select your bank",
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                    const SizedBox(height: 20),
                    Field(
                      padding: const EdgeInsets.all(8),
                      hintText: "Search for a bank",
                      keyboard: TextInputType.text,
                      controller: controller.bankSearch,
                    ),
                    const SizedBox(height: 20),
                    ...controller.state.banks.map((bank) => NavigatorButton(
                      prefixIcon: Icons.house_rounded,
                      header: bank.name,
                      onPressed: () => onPick.call(bank),
                    ))
                  ],
                );
              }
            })
          ],
        ),
      )
    );
  }
}