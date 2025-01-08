import 'package:universal_io/io.dart';

import 'package:flutter/foundation.dart';
import 'package:user/library.dart';

class ExceptionImplementation implements ExceptionService {
  @override
  void handleConnectionException(SocketException socketException) {
    notify.error(message: "An error occurred while accessing your network");
    return;
  }

  @override
  void handleException() {
    FlutterError.onError = (details) {
      if(details.exception is SerchException) {
        SerchException exception = details.exception as SerchException;
        if(exception.isPlatformNotSupported) {
          Navigate.all(PlatformErrorLayout.route, arguments: exception.message);
        }  else if(exception.isLocked) {
          Navigate.all(AccountIssueLayout.route);
        } else if(exception.isSessionExpired) {
          LoginLayout.all();
        }
        if (kDebugMode) {
          // In development mode, simply print to console.
          FlutterError.dumpErrorToConsole(details);
        } else {
          // In production mode, report all uncaught errors to Crashlytics.
          CrashlyticsEngine.handle();
        }
      } else if(details.exception is SerchException) {
        handleConnectionException(details.exception as SocketException);
      } else if (kDebugMode) {
        // In development mode, simply print to console.
        FlutterError.dumpErrorToConsole(details);
      } else {
        // In production mode, report all uncaught errors to Crashlytics.
        CrashlyticsEngine.handle();
      }
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter
    // framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      if(error is SocketException) {
        handleConnectionException(error);
      } else if(error is SerchException) {
        if(error.isPlatformNotSupported) {
          Navigate.all(PlatformErrorLayout.route, arguments: error.message);
        } else if(error.isLocked) {
          Navigate.all(AccountIssueLayout.route);
        } else if(error.isSessionExpired) {
          LoginLayout.all();
        }
      } else if (kDebugMode) {
        // In development mode, simply print to console.
        log(stack, from: "P - ErrorHandler");
        log(error, from: "PE - ErrorHandler");
      } else {
        // In production mode, report all uncaught errors to Crashlytics.
        CrashlyticsEngine.handle();
      }
      CrashlyticsEngine.handle();
      return true;
    };
  }
}