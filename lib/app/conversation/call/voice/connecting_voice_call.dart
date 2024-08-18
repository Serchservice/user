import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ConnectingVoiceCall extends StatelessWidget {
  final ActiveCallResponse call;
  const ConnectingVoiceCall({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      shouldOverride: true,
      backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
      child: Center(
        child: Column(
          children: [
            LinearProgressIndicator(color: Theme.of(context).primaryColor),
            const Expanded(child: SizedBox()),
            Stack(
              children: [
                Avatar(radius: 70, avatar: call.avatar),
                Positioned(
                    right: 5,
                    bottom: 0,
                    child: Avatar(radius: 13, avatar: call.image)
                ),
              ],
            ),
            const SizedBox(height: 20),
            SText(
              text: call.name,
              size: Sizing.font(20),
              color: Theme.of(context).primaryColor,
            ),
            SText(
              text: "Wait a moment while we connect your call...",
              size: Sizing.font(16),
              color: CommonColors.hint,
            ),
            const Expanded(child: SizedBox()),
            Image.asset(
                Media.voiceChat,
                width: 100,
                color: Theme.of(context).primaryColor,
                height: 100
            ),
          ],
        ),
      ),
    );
  }
}