import 'package:flutter/foundation.dart';

class Logger {
  static void log(text, {String? from, bool needHeader = true}){
    if(kDebugMode){
      if(needHeader) {
        debugPrint("From Serch Debug${from ?? ""}_______________________________${text.toString()}");
      } else {
        debugPrint(text.toString());
      }
    }
  }
}