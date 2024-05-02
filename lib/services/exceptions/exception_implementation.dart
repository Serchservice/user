import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:user/library.dart';

class ExceptionImplementation implements ExceptionService {
  @override
  void handleConnectionException(SocketException socketException) {
    Logger.log(socketException, from: "Handler Exception - Socket Exception");
  }

  @override
  void handleException() {
    FlutterError.onError = (details) {
      Logger.log(details, from: "ErrorHandler");
      if(details.exception is SocketException) {
        handleConnectionException(details.exception as SocketException);
      }
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      Logger.log(stackTrace, from: "ErrorHandler");
      Logger.log(exception, from: "ErrorHandler");
      if(exception is SocketException) {
        handleConnectionException(exception);
        return true;
      }
      return true;
    };
  }
}