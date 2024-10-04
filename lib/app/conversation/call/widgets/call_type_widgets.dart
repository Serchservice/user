import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
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
          CallDurationView(controller: controller, text: text),
          const Spacer(),
          CircledButton(
            title: "Call Info",
            icon: Icons.info_outline_rounded,
            iconColor: CommonColors.lightTheme,
            backgroundColor: darkAlternateColor,
            onClick: () => CallInfoView.open(controller: controller),
          )
        ],
      ),
    );
  }
}

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
            onClick: () => CallInfoView.open(controller: controller),
          ),
          const SizedBox(width: 10),
          CircledButton(
            title: "My wallet",
            asset: Media.wallet,
            backgroundColor: darkAlternateColor,
            onClick: () => ViewWalletSheet.open(controller: controller),
          )
        ],
      ),
    );
  }
}

class VoiceCallBottomBar extends StatelessWidget {
  final CallController controller;
  const VoiceCallBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isOnCall = controller.state.call.value.isOnCall;

      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Sizing.space(16),
            horizontal: Sizing.space(4)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircledButton(
              title: "Mic",
              icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
              backgroundColor: darkAlternateColor,
              iconColor: CommonColors.lightTheme,
              onClick: controller.toggleMic,
            ),
            const SizedBox(width: 10),
            CircledButton(
              title: "Speaker",
              icon: controller.state.isOnSpeaker.value ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              backgroundColor: darkAlternateColor,
              iconColor: CommonColors.lightTheme,
              onClick: controller.toggleSpeaker,
            ),
            if(isOnCall) ...[
              const SizedBox(width: 10),
              CircledButton(
                title: "End",
                icon: Icons.call_end_rounded,
                backgroundColor: CommonColors.error,
                iconColor: CommonColors.lightTheme,
                onClick: controller.end,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      child: LoadingButton(
                        text: "Invite",
                        buttonColor: darkAlternateColor,
                        textColor: CommonColors.lightTheme,
                        isCircular: false,
                        borderRadius: 24,
                        onClick: () => CallInfoView.open(controller: controller, showInvite: true),
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizing.space(12),
                            vertical: Sizing.space(4)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircledButton(
                      title: "End",
                      icon: Icons.call_end_rounded,
                      backgroundColor: CommonColors.error,
                      iconColor: CommonColors.lightTheme,
                      onClick: controller.end,
                    )
                  ],
                ),
              ),
            ]
          ],
        ),
      );
    });
  }
}

class Tip2FixCallBottomBar extends StatelessWidget {
  final CallController controller;
  const Tip2FixCallBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Sizing.space(16),
          horizontal: Sizing.space(4)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => CircledButton(
            title: "Mic",
            icon: controller.state.isAudioMuted.value ? Icons.mic_off_rounded : Icons.mic_rounded,
            backgroundColor: darkAlternateColor,
            iconColor: CommonColors.lightTheme,
            onClick: controller.toggleMic,
          )),
          const SizedBox(width: 10),
          Obx(() => CircledButton(
            title: "Camera",
            icon: controller.state.isCameraEnabled.value ? Icons.videocam_rounded : Icons.videocam_off_rounded,
            backgroundColor: darkAlternateColor,
            iconColor: CommonColors.lightTheme,
            onClick: controller.toggleCamera,
          )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircledButton(
                  title: "End",
                  icon: Icons.call_end_rounded,
                  backgroundColor: CommonColors.error,
                  iconColor: CommonColors.lightTheme,
                  onClick: controller.end,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Tip2FixBottomFloater extends StatelessWidget {
  final CallController controller;
  final String? text;

  const Tip2FixBottomFloater({super.key, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            controller.asset,
            width: 20,
            color: Theme.of(context).primaryColor,
            height: 20
          ),
          const SizedBox(height: 5),
          Obx(() {
            if(controller.state.call.value.isOnCall) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SText(
                    text: controller.state.call.value.name,
                    size: Sizing.font(14),
                    weight: FontWeight.bold,
                    color: controller.state.isCameraEnabled.value
                      ? CommonColors.hint
                      : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Sizing.space(4), vertical: Sizing.space(1)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: SText(
                      text: "${controller.state.call.value.session}",
                      size: Sizing.font(14),
                      weight: FontWeight.bold,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  )
                ],
              );
            } else {
              return SText(
                text: controller.state.call.value.name,
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: controller.state.isCameraEnabled.value
                    ? CommonColors.hint
                    : Theme.of(context).primaryColor,
              );
            }
          }),
          CallDurationView(controller: controller, text: text),
        ],
      ),
    );
  }
}

class Tip2FixCallUser extends StatelessWidget {
  final String avatar;
  final String image;
  final double? radius;

  const Tip2FixCallUser({super.key, required this.avatar, required this.image, this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Stack(
          children: [
            Avatar(radius: radius ?? 70, avatar: avatar),
            Positioned(
                right: 5,
                bottom: 0,
                child: Avatar(radius: 13, avatar: image)
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceCallUser extends StatelessWidget {
  final String avatar;
  final String image;
  final double? radius;

  const VoiceCallUser({super.key, required this.avatar, required this.image, this.radius});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Avatar(radius: radius ?? 70, avatar: avatar),
          Positioned(
              right: 5,
              bottom: 0,
              child: Avatar(radius: 13, avatar: image)
          ),
        ],
      ),
    );
  }
}