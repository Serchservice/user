import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

class ActiveTip2FixCall extends StatelessWidget {
  final stream.Call call;
  final ActiveCallResponse active;
  final CallController controller;
  final stream.CallState callState;

  const ActiveTip2FixCall({
    super.key,
    required this.call,
    required this.controller,
    required this.callState,
    required this.active
  });

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
          title: CallDurationView(controller: controller),
          centerTitle: true,
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
        );
      },
      callParticipantsBuilder: (context, call, state) {
        return stream.StreamCallParticipants(
          call: call,
          participants: state.callParticipants,
          enableLocalVideo: true,
          callParticipantBuilder: (context, call, state) {
            return stream.StreamCallParticipant(
              call: call,
              participant: state,
              backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
              videoPlaceholderBuilder: (context, call, state) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Avatar(radius: 70, avatar: state.image),
                          Positioned(
                            right: 5,
                            bottom: 0,
                            child: Avatar(
                              radius: 13,
                              avatar: state.custom.containsKey("image") ? state.custom["image"]!.toString() : ""
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SText(
                        text: state.name,
                        size: Sizing.font(16),
                        color: CommonColors.hint,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      callControlsBuilder: (context, call, callState) {
        return Container(
          color: Theme.of(context).textSelectionTheme.selectionColor,
          padding: EdgeInsets.symmetric(
            vertical: Sizing.space(16),
            horizontal: Sizing.space(4)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    controller.asset,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                    height: 20
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(Sizing.space(4)),
                    color: Theme.of(context).primaryColor,
                    child: Obx(() => SText(
                      text: controller.state.call.value.session.toString(),
                      size: Sizing.font(12),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    )),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
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
                  stream.ToggleCameraOption(
                    call: call,
                    localParticipant: callState.localParticipant!,
                    disabledCameraBackgroundColor: darkAlternateColor,
                    enabledCameraBackgroundColor: darkAlternateColor,
                    disabledCameraIconColor: CommonColors.lightTheme,
                    enabledCameraIconColor: CommonColors.lightTheme,
                  ),
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
            ],
          ),
        );
      },
    );
  }
}