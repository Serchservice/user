import 'package:user/library.dart';
import 'package:get/get.dart';

class GuestBiometricsController extends GetxController {
  GuestBiometricsController();
  final state = GuestBiometricsState();

  bool get hasBiometrics => state.preference.value.hasBiometrics;

  void onClick() async {
    dynamic value = await GuestBiometricsAuthLayout.to(hasBiometrics);

    if(value != null && value is bool) {
      state.preference.value = state.preference.value.copyWith(hasBiometrics: value);

      try {
        GuestPrivacyAndSecurityController.data.state.preference.value = state.preference.value;
      } catch (_) {}
      Navigate.back();
    }
  }
}