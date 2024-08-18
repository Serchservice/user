import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CallDurationView extends StatelessWidget {
  final CallController controller;

  const CallDurationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(5),
      child: Obx(() {
        return SText(
          text: controller.state.duration.value,
          color: Theme.of(context).primaryColor
        );
      }),
    );
  }
}