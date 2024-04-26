import 'package:user/library.dart';

/// Handles rerouting within the app when an error occurs
class SerchException implements Exception {
  String message;
  int? code;
  bool isLocked;
  bool isSessionExpired;
  bool isPlatformNotSupported;

  SerchException(this.message, {
    this.code,
    this.isLocked = false,
    this.isSessionExpired = false,
    this.isPlatformNotSupported = false
  }) {
    Logger.log(toString(), needHeader: false);
  }

  @override
  String toString() {
    if(code != null) {
      return "Serch Exception: $message. Code: $code";
    }
    return "Serch Exception: $message";
  }
}