import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class WalletLayout extends GetResponsiveView<WalletController> {
  static const String route = "/centre/wallet";
  WalletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      appbar: AppBar(
        elevation: 0.5,
        title: SText.center(
          text: "Wallet",
          size: Sizing.font(20),
          weight: FontWeight.bold,
          color: Theme.of(context).primaryColor
        ),
      ),
      child: Column(),
    );
  }
}