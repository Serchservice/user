import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";

class CrashlyticsEngine {
  static final _instance = FirebaseCrashlytics.instance;

  static void handle() async {
    FlutterError.onError = _instance.recordFlutterFatalError;

    FlutterError.onError = (errorDetails) {
      _instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}