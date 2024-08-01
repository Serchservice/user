import 'package:get/get.dart';

class AppInformationState {
  /// App Version
  RxString appVersion = "".obs;

  /// App Name
  RxString appName = "".obs;

  /// App Build Number
  RxString appBuildNumber = "".obs;

  /// App Package
  RxString appPackage = "".obs;

  /// User App Rating value
  RxDouble rating = 5.0.obs;

  /// User comment
  RxString comment = "".obs;

  /// Any unread message from Serch
  RxBool unread = false.obs;

  /// Is loading data
  RxBool isLoading = true.obs;
}