import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class IncomingVoiceCall extends StatelessWidget {
  final CallController controller;

  const IncomingVoiceCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse active = controller.state.call.value;

      return Center(
        child: Column(
          children: [
            VoiceCallTopBar(controller: controller, text: "Incoming"),
            const Spacer(),
            VoiceCallUser(avatar: active.avatar, image: active.image),
            const SizedBox(height: 20),
            SText(
              text: active.name,
              size: Sizing.font(16),
              color: Theme.of(context).primaryColor,
            ),
            const Expanded(child: SizedBox()),
            Image.asset(
              controller.asset,
              width: 100,
              color: Theme.of(context).primaryColor,
              height: 100
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizing.space(16),
                horizontal: Sizing.space(4)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircledButton(
                    title: "End call",
                    icon: Icons.call_end_rounded,
                    backgroundColor: CommonColors.error,
                    iconColor: CommonColors.lightTheme,
                    onClick: controller.end,
                  ),
                  CircledButton(
                    title: "Answer call",
                    icon: Icons.call_rounded,
                    backgroundColor: CommonColors.success,
                    iconColor: CommonColors.lightTheme,
                    onClick: controller.answer,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}