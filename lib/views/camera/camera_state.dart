import 'package:get/get.dart';

class CameraState {
  /// Gallery mode = Chat ("chat") else use the callback_url in the model
  RxBool isChat = false.obs;

  /// Name of the person getting the camera result
  RxString sendTo = "".obs;

  /// Id of the person getting the camera result - Only for chat
  RxString sendToId = "".obs;

  /// Callback url - For none chat selectors
  RxString callbackUrl = "".obs;

  /// Tell whether the flash is on
  RxBool isFlash = false.obs;

  /// Tell whether the user is recording a video
  RxBool isRecording = false.obs;

  /// Tell whether the video recording was paused
  RxBool isPausedRecording = false.obs;

  /// Tell whether the current camera mode is front camera
  RxBool isFrontCamera = false.obs;

  RxBool isFetching = false.obs;

  /// Video recording duration
  RxInt recordDuration = 0.obs;

  /// Video time in minutes and seconds
  RxString videoDuration = "00:00".obs;

  /// Tell if the camera is initialized
  RxBool isCameraInitialized = false.obs;
}