import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class ConnectingTip2FixCall extends StatelessWidget {
  final CallController controller;
  const ConnectingTip2FixCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse active = controller.state.call.value;

      return Center(
        child: Stack(
          children: [
            Tip2FixCallUser(avatar: active.avatar, image: active.image),
            Column(
              children: [
                Tip2FixCallTopBar(controller: controller),
                const Expanded(child: SizedBox()),
                Tip2FixCallBottomBar(controller: controller)
              ],
            ),
            Tip2FixBottomFloater(controller: controller),
          ],
        ),
      );
    });
  }
}