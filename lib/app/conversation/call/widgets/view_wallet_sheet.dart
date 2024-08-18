import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ViewWalletSheet extends StatelessWidget {
  final CallController controller;
  const ViewWalletSheet({super.key, required this.controller});

  static void open({required CallController controller}) {
    Navigate.bottomSheet(
      sheet: ViewWalletSheet(controller: controller),
      route: "/wallet/details",
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