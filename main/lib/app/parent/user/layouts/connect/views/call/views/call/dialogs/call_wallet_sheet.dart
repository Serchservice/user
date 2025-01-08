import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CallWalletSheet extends StatelessWidget {
  final CallController controller;
  const CallWalletSheet({super.key, required this.controller});

  static void open({required CallController controller}) {
    Navigate.bottomSheet(
      sheet: CallWalletSheet(controller: controller),
      route: "/connect/call/${controller.state.call.value.channel}/details/wallet",
      isScrollable: true,
      safeArea: false
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(24),
      backgroundColor: Colors.transparent,
      child: GetX<CallController>(
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WalletView(
                isLoading: controller.state.isFetchingWallet.value,
                wallet: controller.state.wallet.value,
              ),
            ],
          );
        }
      ),
    );
  }
}