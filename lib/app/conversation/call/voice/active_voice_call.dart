import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class ActiveVoiceCall extends StatelessWidget {
  final stream.Call call;
  final CallController controller;
  final stream.CallState callState;

  const ActiveVoiceCall({super.key, required this.call, required this.controller, required this.callState});

  @override
  Widget build(BuildContext context) {
    return stream.StreamCallContent(
      call: call,
      callState: callState,
      pictureInPictureConfiguration: const stream.PictureInPictureConfiguration(
        enablePictureInPicture: true,
        iOSPiPConfiguration: stream.IOSPictureInPictureConfiguration(
          ignoreLocalParticipantVideo: false,
        ),
      ),
      callAppBarBuilder: (context, call, callState) {
        return AppBar(
          backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
          title: CallDurationView(controller: controller),
          centerTitle: true,
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
        );
      },
      callControlsBuilder: (context, call, callState) {
        return Container(
          color: Theme.of(context).textSelectionTheme.selectionColor,
          padding: EdgeInsets.symmetric(
              vertical: Sizing.space(16),
              horizontal: Sizing.space(4)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              stream.ToggleMicrophoneOption(
                call: call,
                localParticipant: callState.localParticipant!,
                disabledMicrophoneBackgroundColor: darkAlternateColor,
                enabledMicrophoneBackgroundColor: darkAlternateColor,
                disabledMicrophoneIconColor: CommonColors.lightTheme,
                enabledMicrophoneIconColor: CommonColors.lightTheme,
              ),
              stream.ToggleSpeakerphoneOption(call: call),
              stream.LeaveCallOption(
                call: call,
                icon: Icons.call_end_rounded,
                onLeaveCallTap: () => controller.end(),
              ),
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
            ],
          ),
        );
      },
    );
  }
}