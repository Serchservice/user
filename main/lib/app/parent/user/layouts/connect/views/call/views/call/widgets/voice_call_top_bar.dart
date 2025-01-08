import 'package:flutter/material.dart';
import 'package:user/library.dart';

class VoiceCallTopBar extends StatelessWidget {
  final CallController controller;
  final String? text;
  const VoiceCallTopBar({super.key, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GoBack(onTap: () => controller.goBack(false, null), icon: Icons.arrow_back),
          const Spacer(),
          CallDuration(controller: controller, text: text),
          const Spacer(),
          CircledButton(
            title: "Call Info",
            icon: Icons.info_outline_rounded,
            iconColor: CommonColors.lightTheme,
            backgroundColor: darkAlternateColor,
            onClick: () => CallDetailSheet.open(controller: controller),
          )
        ],
      ),
    );
  }
}