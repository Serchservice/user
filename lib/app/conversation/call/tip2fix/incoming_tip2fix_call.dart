import 'package:flutter/material.dart';
import 'package:user/library.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class IncomingTip2FixCall extends StatelessWidget {
  final stream.Call call;
  final ActiveCallResponse active;
  final CallController controller;
  final stream.CallState callState;

  const IncomingTip2FixCall({
    super.key,
    required this.call,
    required this.controller,
    required this.callState,
    required this.active
  });

  @override
  Widget build(BuildContext context) {
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircledButton(
              title: "My wallet",
              asset: Media.wallet,
              backgroundColor: darkAlternateColor,
              onClick: () => ViewWalletSheet.open(controller: controller),
            ),
          )
        ],
      ),
      child: Center(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const Expanded(child: SizedBox()),
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
                  SText(
                    text: "Incoming",
                    size: Sizing.font(16),
                    color: CommonColors.hint,
                  ),
                  const Expanded(child: SizedBox()),
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
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 120,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  height: 250,
                  width: 160,
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  child: stream.StreamCallParticipant(
                    call: call,
                    participant: callState.localParticipant!,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
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
                  SText(
                    text: active.name,
                    size: Sizing.font(14),
                    weight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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