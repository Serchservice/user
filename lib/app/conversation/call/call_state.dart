import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class CallState {
  Rx<ActiveCallResponse> call = ActiveCallResponse.empty().obs;
  /// Call time in int
  /// Call time in string
  RxString time = RxString("00:00:00");

  /// Switching between different call types
  RxBool isRequestingSwitch = RxBool(false);

  /// Call speaker on volume out
  RxBool isOnSpeaker = RxBool(false);

  /// Microphone is muted
  RxBool isAudioMuted = RxBool(false);

  /// User is answering with bluetooth
  RxBool isOnBluetooth = RxBool(false);

  /// Checks if Agora Engine is initialized
  RxBool isInitialized = RxBool(false);

  /// Checks if Agora preview is ready for display
  RxBool isPreviewReady = RxBool(false);

  /// Checks if the call camera is muted
  RxBool isVideoMuted = RxBool(false);

  /// Checks if the call is on speaker
  RxBool isSpeaker = RxBool(false);

  /// Call time out
  RxInt timeout = 60.obs;

  /// Call duration in seconds
  RxString seconds = "".obs;

  /// Call duration in hours
  RxString hours = "".obs;

  /// Call duration in minutes
  RxString minutes = "".obs;
}