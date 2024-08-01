import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:user/library.dart';

class VoiceCall extends StatelessWidget {
  final CallController controller;
  const VoiceCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse call = controller.state.call.value;

      return MainLayout(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GoBack()
                ],
              ),
              Avatar(radius: 70, avatar: call.avatar),
              const SizedBox(height: 20),
              SText(
                text: call.name,
                size: Sizing.font(20),
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 10),
              if(call.isOnCall)...[
                SText(
                  text: controller.state.time.value,
                  size: Sizing.font(24),
                  color: Theme.of(context).primaryColor,
                )
              ] else ...[
                SText(
                  text: call.status.type,
                  size: Sizing.font(16),
                  color: CommonColors.hint,
                )
              ],
              const Expanded(child: SizedBox()),
              Image.asset(
                Media.voiceChat,
                width: 100,
                color: Theme.of(context).primaryColor,
                height: 100
              ),
              const Expanded(child: SizedBox()),
              Container(
                padding: EdgeInsets.all(Sizing.space(12)),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: _buildButton(context, call)
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildButton(BuildContext context, ActiveCallResponse call) {
    if(call.isMissed || call.isDisconnected) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircledButton(
            title: "Leave",
            icon: Icons.close,
            onClick: () => Navigate.till(ModalRoute.withName(HomeLayout.route)),
          ),
          const Expanded(child: SizedBox()),
          CircledButton(
            title: "Call",
            icon: Icons.call,
            onClick: () => RouteNavigator.makeCall(name: call.name, avatar: call.avatar, user: call.user, type: call.type),
          )
        ],
      );
    } else if(call.isOnCall) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => CircledButton(
            title: controller.state.isAudioMuted.value ? "Un-mute" : "Mute",
            icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
            onClick: () => controller.toggleMute(),
          )),
          const Expanded(child: SizedBox()),
          CircledButton(
            title: "End call",
            icon: Icons.call_end_rounded,
            onClick: () => controller.end(),
            isBig: true,
            iconColor: CommonColors.lightTheme,
            backgroundColor: CommonColors.error,
          ),
        ],
      );
    } else if(call.isCaller) {
      return CircledButton(
        title: "End call",
        icon: Icons.call_end_rounded,
        onClick: () => controller.end(),
        isBig: true,
        iconColor: CommonColors.lightTheme,
        backgroundColor: CommonColors.error,
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircledButton(
            title: "Answer call",
            icon: Icons.call,
            onClick: () => controller.answer(),
            isBig: true,
            iconColor: CommonColors.lightTheme,
            backgroundColor: CommonColors.success,
          ),
          const Expanded(child: SizedBox()),
          CircledButton(
            title: "End call",
            icon: Icons.call_end_rounded,
            onClick: () => controller.end(),
            isBig: true,
            iconColor: CommonColors.lightTheme,
            backgroundColor: CommonColors.error,
          ),
        ],
      );
    }
  }
}