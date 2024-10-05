import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class MfaAuthController extends GetxController {
  MfaAuthController();
  final state = MfaAuthState();

  final ConnectService _connect = Connect();

  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  final route = Get.currentRoute;

  @override
  void onInit() {
    if(route.endsWith(MfaAuthLayout.loginRoute)) {
      state.authMode.value = MfaAuth.login;
    } else if(route.endsWith(MfaAuthLayout.enableRoute)) {
      state.authMode.value = MfaAuth.enable;
    } else {
      state.authMode.value = MfaAuth.disable;
    }

    super.onInit();
  }

  @override
  void onClose() {
    authController.dispose();
    authFocusNode.dispose();

    super.onClose();
  }

  /// Login with Mfa
  bool get isLogin => state.authMode.value == MfaAuth.login;

  /// Enable MFA
  bool get isEnable => state.authMode.value == MfaAuth.enable;

  /// Disable MFA
  bool get isDisable => state.authMode.value == MfaAuth.disable;

  void verify({String? code}) {
    if(isLogin && state.isRecovery.value) {
      authenticateWithRecoveryCode(code: code);
    } else if(isLogin) {
      authenticateWithTotp(code: code);
    } else if(isEnable) {
      enable(code: code);
    } else if(isDisable) {
      disableAuth();
    }
  }

  void enable({String? code}) async {
    if(code != null) {
      state.token.value = code;
    }

    if(state.token.value.isEmpty || state.token.value.length < 6) {
      notify.error(message: "Incorrect token");
      return;
    } else {
      state.isVerifying.value = true;
      var response = await _connect.post(
        endpoint: "/auth/mfa/verify/code",
        body: {"code": state.token.value, "device": Database.device.toJson()}
      );
      state.isVerifying.value = false;
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);

        try {
          PrivacyAndSecurityController controller = Get.find<PrivacyAndSecurityController>();
          controller.state.auth.value = auth;
        } catch (_) {}
        Navigate.back(result: true);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  List<String> buttons = ["Recovery Code", "Authenticator Code"];

  void toggle(int button) {
    if(button == 0) {
      state.isRecovery.value = true;
    } else {
      state.isRecovery.value = false;
    }
  }

  void authenticateWithRecoveryCode({String? code}) async {
    if(code != null) {
      state.token.value = code;
    }

    if(state.token.value.isEmpty || state.token.value.length < 6) {
      notify.warn(message: "Incorrect token");
      return;
    } else {
      state.isVerifying.value = true;
      var response = await _connect.post(
          endpoint: "/auth/mfa/recovery/code/verify",
          body: {"code": state.token.value, "device": Database.device.toJson()}
      );
      state.isVerifying.value = false;
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        if(isLogin) {
          Database.savePreference(Database.preference.copyWith(isAuthenticated: true));
          Navigate.all(HomeLayout.route);
        } else {
          Navigate.back();
        }
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void authenticateWithTotp({String? code}) async {
    if(code != null) {
      state.token.value = code;
    }

    if(state.token.value.isEmpty || state.token.value.length < 6) {
      notify.warn(message: "Incorrect token");
      return;
    } else {
      state.isVerifying.value = true;
      var response = await _connect.post(
        endpoint: "/auth/mfa/verify/code",
        body: {"code": state.token.value, "device": Database.device.toJson()}
      );
      state.isVerifying.value = false;
      if(response.isOk) {
        AuthResponse auth = AuthResponse.fromJson(response.data);
        Database.saveAuth(auth);
        if(isLogin) {
          Database.savePreference(Database.preference.copyWith(isAuthenticated: true));
          Navigate.all(HomeLayout.route);
        } else {
          Navigate.back();
        }
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void disableAuth() async {
    state.isVerifying.value = true;
    ApiResponse response = await _connect.delete(endpoint: "/auth/mfa/disable", body: Database.device.toJson());
    state.isVerifying.value = false;
    if(response.isOk) {
      AuthResponse auth = AuthResponse.fromJson(response.data);
      Database.saveAuth(auth);
      Navigate.back(result: true);
    } else {
      notify.error(message: response.message);
    }
  }
}