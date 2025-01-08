import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ConnectingVoiceCall extends StatelessWidget {
  final CallController controller;
  const ConnectingVoiceCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse active = controller.state.call.value;

      return Center(
        child: Column(
          children: [
            VoiceCallTopBar(controller: controller),
            const Spacer(),
            VoiceCallUser(avatar: active.avatar, image: active.image),
            const SizedBox(height: 20),
            SText(
              text: active.name,
              size: Sizing.font(16),
              color: Theme.of(context).primaryColor,
            ),
            const Spacer(),
            Image.asset(
              controller.asset,
              width: 100,
              color: Theme.of(context).primaryColor,
              height: 100
            ),
            const Spacer(),
            VoiceCallBottomBar(controller: controller)
          ],
        ),
      );
    });
  }
}