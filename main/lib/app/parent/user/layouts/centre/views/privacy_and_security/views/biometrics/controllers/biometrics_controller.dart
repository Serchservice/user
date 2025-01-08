import 'package:user/library.dart';
import 'package:get/get.dart';

class BiometricsController extends GetxController {
  BiometricsController();
  final state = BiometricsState();

  bool get hasBiometrics => state.preference.value.hasBiometrics;

  void onClick() async {
    dynamic value = await BiometricsAuthLayout.to(hasBiometrics);

    if(value != null && value is bool) {
      state.preference.value = state.preference.value.copyWith(hasBiometrics: value);

      try {
        PrivacyAndSecurityController.data.state.preference.value = state.preference.value;
      } catch (_) {}
      Navigate.back();
    }
  }
}