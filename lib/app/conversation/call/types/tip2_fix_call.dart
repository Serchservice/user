import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class Tip2FixCall extends StatelessWidget {
  final CallController controller;
  const Tip2FixCall({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ActiveCallResponse call = controller.state.call.value;

      return MainLayout(
        needSafeArea: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        child: Stack(
          children: [
            _buildFullView(context),
            Align(
              alignment: Alignment.bottomRight,
              child: _buildFloatingView(context),
            ),
            ..._buildBottomView(context, call)
          ],
        ),
      );
    });
  }

  Widget _buildFullView(BuildContext context) {
    return Obx(() {
      if(controller.state.isInitialized.value) {
        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: controller.engine,
            canvas: const VideoCanvas(uid: 1),
            connection: RtcConnection(channelId: controller.state.call.value.channel, localUid: 1)
          ),
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: CommonColors.darkTheme,
          child: Center(
            child: SText(
              text: "Waiting for user to join...",
              size: Sizing.font(14),
            ),
          ),
        );
      }
    });
  }

  Widget _buildFloatingView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 150,
        width: 100,
        child: Obx(() {
          if(controller.state.isInitialized.value) {
            return AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: controller.engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: CommonColors.darkTheme,
            );
          }
        }),
      ),
    );
  }

  List<Widget> _buildBottomView(BuildContext context, ActiveCallResponse call) {
    return [
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          margin: EdgeInsets.all(Sizing.space(12)),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20)
          ),
          child: _buildButton(context, call),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar.small(avatar: call.avatar),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(
                      text: call.name,
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    if(call.isOnCall)...[
                      SText(
                        text: controller.state.time.value,
                        size: Sizing.font(14),
                        color: Theme.of(context).primaryColor,
                      )
                    ] else ...[
                      SText(
                        text: call.status.type,
                        size: Sizing.font(14),
                        color: CommonColors.hint,
                      )
                    ],
                  ],
                )
              ),
              const SizedBox(width: 6),
              CircledButton(
                title: "View call details",
                asset: Media.wallet,
                backgroundColor: CommonColors.darkTheme2,
                onClick: () => {},
              )
            ],
          )
        ),
      ),
    ];
  }

  Widget _buildButton(BuildContext context, ActiveCallResponse call) {
    return Obx(() {
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
            const Expanded(child: SizedBox()),
            CircledButton(
              title: "Switch camera",
              icon: Icons.switch_camera_outlined,
              onClick: () => controller.switchCamera(),
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
    });
  }
}