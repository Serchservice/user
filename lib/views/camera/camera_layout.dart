import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

/// {"mode": "chat", "to": "Frank", "to_id": "1234", "callback_url": "/home"}
class CameraLayout extends GetResponsiveView<CameraLayoutController> {
  static const String route = "/camera";
  CameraLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      extendBehindAppbar: true,
      appbar: AppBar(
        actions: [
          IconButton(
            splashRadius: 25,
            onPressed: () => controller.setFlash(),
            icon: Obx(() => Icon(
              controller.state.isFlash.value
                ? Icons.flash_on_outlined
                : Icons.flash_off_outlined,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22)
            ))
          ),
          const SizedBox(width: 20),
          IconButton(
            splashRadius: 25,
            onPressed: () => controller.flipCamera(),
            icon: Icon(
              Icons.cameraswitch_rounded,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(22)
            )
          )
        ],
      ),
      floaterPosition: 0,
      floater: Obx(() {
        if(controller.state.isChat.value) {
          if(controller.state.isRecording.value) {
            return CameraRecordingView(controller: controller);
          } else if(controller.state.isPausedRecording.value) {
            return CameraPausedRecordingView(controller: controller);
          } else {
            return CameraChatView(controller: controller);
          }
        } else {
          return CameraNormalView(controller: controller);
        }
      }),
      child: CameraScreen(controller: controller)
    );
  }
}

class CameraRecordingView extends StatelessWidget {
  const CameraRecordingView({super.key, required this.controller});

  final CameraLayoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => CircularProgressIndicator(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          valueColor: const AlwaysStoppedAnimation<Color>(CommonColors.error),
          value: controller.state.recordDuration.value / controller.maxDuration,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => controller.pauseRecording(),
              icon: Icon(
                Icons.pause,
                size: Sizing.font(50),
                color: CommonColors.error
              )
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => controller.stopRecording(),
              icon: Icon(
                Icons.stop_circle_rounded,
                size: Sizing.font(50),
                color: CommonColors.error
              )
            ),
          ],
        ),
        Obx(() => HeartBeating(
          child: SText(
            text: controller.state.videoDuration.value,
            size: Sizing.font(16),
            color: CommonColors.error
          ),
        ))
      ],
    );
  }
}

class CameraPausedRecordingView extends StatelessWidget {
  const CameraPausedRecordingView({super.key, required this.controller});

  final CameraLayoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => CircularProgressIndicator(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          valueColor: const AlwaysStoppedAnimation<Color>(CommonColors.error),
          value: controller.state.recordDuration.value / controller.maxDuration,
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => controller.continueRecording(),
              icon: Icon(
                Icons.videocam_rounded,
                size: Sizing.font(50),
                color: CommonColors.error
              )
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => controller.stopRecording(),
              icon: Icon(
                Icons.stop_circle_rounded,
                size: Sizing.font(50),
                color: CommonColors.error
              )
            ),
          ],
        ),
        Obx(() => HeartBeating(
          child: SText(
            text: controller.state.videoDuration.value,
            size: Sizing.font(16),
            color: CommonColors.error
          ),
        ))
      ],
    );
  }
}

class CameraChatView extends StatelessWidget {
  const CameraChatView({super.key, required this.controller});

  final CameraLayoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => controller.takePhoto(),
          icon: Icon(
            Icons.photo_camera_rounded,
            size: Sizing.font(50),
            color: Theme.of(context).primaryColor
          )
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () => controller.recordVideo(),
          icon: Icon(
            Icons.radio_button_on_rounded,
            size: Sizing.font(50),
            color: Theme.of(context).primaryColor
          )
        ),
      ],
    );
  }
}

class CameraNormalView extends StatelessWidget {
  const CameraNormalView({super.key, required this.controller});

  final CameraLayoutController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          margin: EdgeInsets.all(Sizing.space(12)),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarTheme.color,
            shape: BoxShape.circle
          ),
          child: IconButton(
            onPressed: () => controller.takePhoto(),
            icon: Icon(
              Icons.photo_camera_rounded,
              size: Sizing.font(50),
              color: Theme.of(context).primaryColor
            )
          ),
        )
      ],
    );
  }
}

class CameraScreen extends StatelessWidget {
  final CameraLayoutController controller;
  const CameraScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isCameraInitialized.value) {
        return controller.state.isPausedRecording.value
          ? controller.cameraController.buildPreview()
          : CameraPreview(controller.cameraController);
      } else {
        return Container(
          color: Theme.of(context).bottomAppBarTheme.color
        );
      }
    });
  }
}