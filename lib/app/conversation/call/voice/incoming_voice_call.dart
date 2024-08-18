import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class IncomingVoiceCall extends StatelessWidget {
  final stream.Call call;
  final ActiveCallResponse active;
  final CallController controller;
  final stream.CallState callState;

  const IncomingVoiceCall({
    super.key,
    required this.call,
    required this.controller,
    required this.callState,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
    List<stream.UserInfo> participants = callState.otherParticipants.map((e) => e.toUserInfo()).toList();

    return MainLayout(
      shouldOverride: true,
      backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
      appbar: AppBar(
        backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
        leading: GoBack(onTap: () => controller.goBack(false, null), icon: Icons.arrow_back),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircledButton(
              title: "Call Info",
              icon: Icons.info_outline_rounded,
              iconColor: CommonColors.lightTheme,
              backgroundColor: darkAlternateColor,
              onClick: () => CallInfoView.open(controller: controller),
            ),
          )
        ],
      ),
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            Stack(
              children: [
                Avatar(radius: 70, avatar: active.avatar),
                Positioned(
                  right: 5,
                  bottom: 0,
                  child: Avatar(radius: 13, avatar: active.image)
                ),
              ],
            ),
            const SizedBox(height: 20),
            SText(
              text: active.name,
              size: Sizing.font(20),
              color: Theme.of(context).primaryColor,
            ),
            SText(
              text: "Incoming",
              size: Sizing.font(16),
              color: CommonColors.hint,
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
                  stream.CallControlOption(
                    icon: const Icon(Icons.call_end_rounded),
                    iconColor: Colors.white,
                    backgroundColor: Colors.red,
                    onPressed: controller.decline,
                    padding: const EdgeInsets.all(24),
                  ),
                  stream.CallControlOption(
                    icon: const Icon(Icons.call_rounded),
                    iconColor: Colors.white,
                    backgroundColor: Colors.green,
                    onPressed: controller.answer,
                    padding: const EdgeInsets.all(24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}