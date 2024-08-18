import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import 'package:user/library.dart';

/// Argument: {"call": [ActiveCallResponse], "answer": "true" | "false", "start": "true" | "false"}
class CallLayout extends GetResponsiveView<CallController> {
  static const String route = "/call";
  CallLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: controller.goBack,
      child: Obx(() {
        if(controller.state.call.value.isVoice) {
          if(stream.StreamVideo.isInitialized() && controller.state.isInitialized.value) {
            return MainLayout(
              shouldOverride: true,
              backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
              child: stream.StreamCallContainer(
                call: controller.streamCall,
                callConnectOptions: stream.CallConnectOptions(camera: stream.TrackOption.disabled()),
                outgoingCallBuilder: (context, call, callState) {
                  return OutgoingVoiceCall(
                    call: call,
                    controller: controller,
                    callState: callState,
                    active: controller.state.call.value
                  );
                },
                incomingCallBuilder: (context, call, callState) {
                  return IncomingVoiceCall(
                    call: call,
                    controller: controller,
                    callState: callState,
                    active: controller.state.call.value
                  );
                },
                callContentBuilder: (context, call, callState) {
                  return ActiveVoiceCall(call: call, controller: controller, callState: callState);
                },
              ),
            );
          } else {
            return ConnectingVoiceCall(call: controller.state.call.value);
          }
        } else {
          if(stream.StreamVideo.isInitialized() && controller.state.isInitialized.value) {
            return MainLayout(
              shouldOverride: true,
              backgroundColor: Theme.of(context).textSelectionTheme.selectionColor,
              child: stream.StreamCallContainer(
                call: controller.streamCall,
                callConnectOptions: stream.CallConnectOptions(
                  camera: stream.TrackOption.enabled(),
                  speakerDefaultOn: true,
                ),
                incomingCallBuilder: (context, call, callState) {
                  return IncomingTip2FixCall(
                    call: call,
                    controller: controller,
                    callState: callState,
                    active: controller.state.call.value
                  );
                },
                outgoingCallBuilder: (context, call, callState) {
                  return OutgoingTip2FixCall(
                    call: call,
                    controller: controller,
                    callState: callState,
                    active: controller.state.call.value
                  );
                },
                callContentBuilder: (context, call, callState) {
                  return ActiveTip2FixCall(
                    call: call,
                    controller: controller,
                    callState: callState,
                    active: controller.state.call.value
                  );
                },
              ),
            );
          } else {
            return ConnectingTip2FixCall(call: controller.state.call.value);
          }
        }
      }),
    );
  }
}