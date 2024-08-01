import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// Argument: {"call": [ActiveCallResponse], "answer": "true" | "false", "start": "true" | "false"}
class CallLayout extends GetResponsiveView<CallController> {
  static const String route = "/call";
  CallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.call.value.isVoice) {
        return VoiceCall(controller: controller);
      } else {
        return Tip2FixCall(controller: controller);
      }
    });
  }
}