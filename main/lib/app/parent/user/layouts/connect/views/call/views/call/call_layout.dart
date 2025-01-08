import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

class CallLayout extends GetResponsiveView<CallController> {
  static const String route = "/connect/call";

  static void call({
    bool removeCurrentRoute = true,
    required String name,
    required String avatar,
    required String user,
    required CallType type
  }) {
    ActiveCallResponse call = ActiveCallResponse.call(name: name, avatar: avatar, user: user, type: type);
    CallLayout._navigate(removeCurrentRoute: removeCurrentRoute, call: call);
  }

  static void go({bool removeCurrentRoute = true, required ActiveCallResponse call}) {
    CallLayout._navigate(removeCurrentRoute: removeCurrentRoute, call: call);
  }

  static void _navigate({required bool removeCurrentRoute, required ActiveCallResponse call}) {
    Map<String, String> params = {"user": call.user, "type": call.type.type};
    Map<String, dynamic> args = {"call": call.toJson()};

    if(removeCurrentRoute) {
      Navigate.offTill(
        CallLayout.route,
        ModalRoute.withName(ParentLayout.route),
        parameters: params,
        arguments: args
      );
    } else {
      Navigate.to(CallLayout.route, parameters: params, arguments: args);
    }
  }

  CallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: controller.goBack,
      child: MainLayout(
        shouldOverride: true,
        backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
        child: Obx(() {
          if(controller.state.call.value.isVoice) {
            if(stream.StreamVideo.isInitialized() && controller.state.isInitialized.value) {
              return stream.StreamCallContainer(
                call: controller.streamCall,
                callConnectOptions: stream.CallConnectOptions(
                  camera: stream.TrackOption.disabled(),
                  microphone: controller.state.isAudioMuted.value
                      ? stream.TrackOption.disabled()
                      : stream.TrackOption.enabled(),
                  speakerDefaultOn: controller.state.isOnSpeaker.value
                ),
                pictureInPictureConfiguration: stream.PictureInPictureConfiguration(
                  enablePictureInPicture: false,
                  androidPiPConfiguration: stream.AndroidPictureInPictureConfiguration(
                    callPictureInPictureBuilder: (context, call, callState) {
                      return PipView(controller: controller);
                    }
                  ),
                  iOSPiPConfiguration: stream.IOSPictureInPictureConfiguration(
                    ignoreLocalParticipantVideo: controller.state.call.value.isOnCall
                  )
                ),
                outgoingCallBuilder: (context, call, callState) {
                  return OutgoingVoiceCall(controller: controller);
                },
                incomingCallBuilder: (context, call, callState) {
                  return IncomingVoiceCall(controller: controller);
                },
                callContentBuilder: (context, call, callState) {
                  if(call.isActiveCall) {
                    return ActiveVoiceCall(controller: controller);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return ConnectingVoiceCall(controller: controller);
            }
          } else {
            if(stream.StreamVideo.isInitialized() && controller.state.isInitialized.value) {
              return stream.StreamCallContainer(
                call: controller.streamCall,
                callConnectOptions: stream.CallConnectOptions(
                  camera: stream.TrackOption.enabled(),
                  microphone: controller.state.isAudioMuted.value
                      ? stream.TrackOption.disabled()
                      : stream.TrackOption.enabled(),
                  speakerDefaultOn: true
                ),
                pictureInPictureConfiguration: stream.PictureInPictureConfiguration(
                  enablePictureInPicture: false,
                  androidPiPConfiguration: stream.AndroidPictureInPictureConfiguration(
                    callPictureInPictureBuilder: (context, call, callState) {
                      return PipView(controller: controller);
                    }
                  ),
                  iOSPiPConfiguration: stream.IOSPictureInPictureConfiguration(
                    ignoreLocalParticipantVideo: controller.state.call.value.isOnCall
                  )
                ),
                incomingCallBuilder: (context, call, callState) {
                  return IncomingTip2FixCall(controller: controller);
                },
                outgoingCallBuilder: (context, call, callState) {
                  return OutgoingTip2FixCall(controller: controller);
                },
                callContentBuilder: (context, call, callState) {
                  if(call.isActiveCall) {
                    return ActiveTip2FixCall(controller: controller);
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return ConnectingTip2FixCall(controller: controller);
            }
          }
        }),
      ),
    );
  }
}

class PipView extends StatelessWidget {
  final CallController controller;

  const PipView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      shouldOverride: true,
      backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
      child: Obx(() {
        ActiveCallResponse active = controller.state.call.value;

        return VoiceCallUser(avatar: active.avatar, image: active.image, radius: 50);
      })
    );
  }
}