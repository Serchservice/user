import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:user/library.dart';

class ExceptionImplementation implements ExceptionService {
  @override
  void handleConnectionException(SocketException socketException) {
    log(socketException, from: "Handler Exception - Socket Exception");
  }

  @override
  void handleException() {
    CrashlyticsEngine.handle();

    FlutterError.onError = (details) {
      log(details, from: "F - ErrorHandler");
      if(details.exception is SocketException) {
        handleConnectionException(details.exception as SocketException);
      }
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      log(stackTrace, from: "P - ErrorHandler");
      log(exception, from: "PE - ErrorHandler");
      if(exception is SocketException) {
        handleConnectionException(exception);
        return true;
      }
      return false;
    };
  }
}