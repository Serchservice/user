import 'dart:io';

abstract class ExceptionService {
  /// SOCKETEXCEPTION ~~
  void handleConnectionException(SocketException socketException);

  /// EXCEPTION ~~
  void handleException();
}