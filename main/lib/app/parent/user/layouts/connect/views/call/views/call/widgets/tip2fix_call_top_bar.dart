import 'package:flutter/material.dart';
import 'package:user/library.dart';

class Tip2FixCallTopBar extends StatelessWidget {
  final CallController controller;

  const Tip2FixCallTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GoBack(
            color: CommonColors.hint,
            onTap: () => controller.goBack(false, null),
            icon: Icons.arrow_back
          ),
          const Spacer(),
          CircledButton(
            title: "Call Info",
            icon: Icons.info_outline_rounded,
            iconColor: CommonColors.lightTheme,
            backgroundColor: darkAlternateColor,
            onClick: () => CallDetailSheet.open(controller: controller),
          ),
          const SizedBox(width: 10),
          CircledButton(
            title: "My wallet",
            asset: Media.wallet,
            backgroundColor: darkAlternateColor,
            onClick: () => CallWalletSheet.open(controller: controller),
          )
        ],
      ),
    );
  }
}