import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class CameraLayoutController extends GetxController {
  CameraLayoutController();
  final state = CameraState();
  final MainConfiguration config = Get.find<MainConfiguration>();

  late CameraController cameraController;
  Timer? timer;
  final int maxDuration = 30;

  final _args = Get.parameters;

  @override
  void onInit() {
    state.isChat.value = bool.tryParse(_args["is_chat"] ?? "") ?? false;
    state.sendTo.value = _args["name"] ?? "";
    state.callbackUrl.value = _args["callback_url"] ?? "";
    state.sendToId.value = _args["id"] ?? "";

    initCamera();
    super.onInit();
  }

  @override
  void onReady() {
    cameraController.addListener(onCameraStateChanged);
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    cameraController.dispose();
    disposeCameraResources();
    cameraController.removeListener(onCameraStateChanged);

    super.onClose();
  }

  void onCameraStateChanged() {
    if(!cameraController.value.isRecordingVideo) {
      state.isRecording.value = false;
      state.isPausedRecording.value = false;
    }
  }

  void closeCameraAndGoBack() {
    state.isCameraInitialized.value = false;
    state.isFlash.value = false;
    state.isPausedRecording.value = false;
    state.isRecording.value = false;

    Get.back();
  }

  void continueRecording() async {
    startTimer();

    await cameraController.resumeVideoRecording();
    state.isRecording.value = true;
    state.isPausedRecording.value = false;
  }

  void flipCamera() {
    timer?.cancel();

    state.isCameraInitialized.value = false;
    state.isFrontCamera.toggle();
    state.recordDuration.value = 0;

    initCamera();
  }

  void initCamera() async {
    int position = state.isFrontCamera.value ? 1 : 0;

    cameraController = CameraController(config.cameras[position], ResolutionPreset.high);
    try {
      await cameraController.initialize();
      state.isCameraInitialized.value = true;

      if(state.isFlash.value){
        cameraController.setFlashMode(FlashMode.torch);
      } else {
        cameraController.setFlashMode(FlashMode.off);
      }
    } on CameraException catch (e) {
      String error = "An error occurred with camera settings";
      switch (e.code) {
        case 'CameraAccessDenied':
          error = e.description ?? "Camera access is denied";
          break;
        case 'AudioAccessDenied':
          error = e.description ?? "Audio access is denied";
          break;
        default:
          error = e.description ?? "Camera access is denied";
          break;
      }

      notify.error(message: error);
    }
  }

  void pauseRecording() async {
    timer?.cancel();

    await cameraController.pauseVideoRecording();
    state.isRecording.value = false;
    state.isPausedRecording.value = true;
  }

  void recordVideo() async {
    if(state.isRecording.value && !state.isPausedRecording.value) {
      pauseRecording();
    } else if(state.isPausedRecording.value && !state.isRecording.value) {
      continueRecording();
    } else {
      startRecording();
    }
  }

  void setFlash() {
    if(state.isFlash.value) {
      cameraController.setFlashMode(FlashMode.off);
      state.isFlash.value = false;
    } else {
      state.isFlash.value = true;
      cameraController.setFlashMode(FlashMode.torch);
    }
  }

  String formatNumberToTime(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      state.recordDuration.value++;

      String minutes = formatNumberToTime(state.recordDuration.value ~/ 60);
      String seconds = formatNumberToTime(state.recordDuration.value % 60);
      state.videoDuration.value = "$minutes : $seconds";

      if(state.recordDuration.value == maxDuration) {
        stopRecording();
      }
    });
  }

  void startRecording() async {
    await cameraController.startVideoRecording();
    startTimer();
    state.isRecording.value = true;
  }

  Future<SelectedMedia?> stopVideoRecording(CameraController camController) async {
    try{
      XFile cameraPath = await camController.stopVideoRecording();
      final size = AssetUtility.getFileSize(xFile: cameraPath);

      return SelectedMedia(
        path: cameraPath.path,
        size: size ?? "",
        media: MediaType.video,
        data: await cameraPath.readAsBytes()
      );
    } on CameraException catch (e) {
      notify.error(message: e.description ?? "Couldn't capture. Try again");
      return null;
    }
  }

  void stopRecording() async {
    timer?.cancel();

    state.recordDuration.value = 0;
    state.isRecording.value = false;
    state.isPausedRecording.value = false;
    state.isFetching.value = true;

    final result = await stopVideoRecording(cameraController).whenComplete(() {
      state.isFetching.value = false;
    });

    if(result != null && !state.isFetching.value) {
      result.copyWith(duration: state.videoDuration.value, isCamera: true);
      disposeCameraResources();
      // Navigate.off(ViewAndSendLayout.route, arguments: {
      //   "data": result.toJsonString(result),
      //   "send_to": state.sendTo.value,
      //   "send_to_id": state.sendToId.value
      // });
    }
  }

  Future<SelectedMedia?> takePicture(CameraController camController) async {
    try{
      XFile cameraPath = await camController.takePicture();
      final size = AssetUtility.getFileSize(xFile: cameraPath);

      return SelectedMedia(
        path: cameraPath.path,
        size: size ?? "",
        media: MediaType.photo,
        data: await cameraPath.readAsBytes(),
        isCamera: true
      );
    } on CameraException catch (e) {
      notify.error(message: e.description ?? "Couldn't capture. Try again");
      return null;
    }
  }

  void takePhoto() async {
    final result = await takePicture(cameraController);

    if(state.isFlash.value){
      cameraController.setFlashMode(FlashMode.off);
    }

    if(result != null) {
      if(state.isChat.value) {
        // Navigate.off(ViewAndSendLayout.route, arguments: {
        //   "data": result.toJsonString(result),
        //   "send_to": state.sendTo.value,
        //   "send_to_id": state.sendToId.value
        // });
      } else {
        Navigate.back(result: result.toJson());
      }
    }
  }

  void disposeCameraResources() {
    cameraController.dispose();
    cameraController.removeListener(onCameraStateChanged);
    state.isCameraInitialized.value = false;
    state.isRecording.value = false;
    state.isPausedRecording.value = false;
    state.recordDuration.value = 0;
  }
}