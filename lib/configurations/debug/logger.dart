import 'package:flutter/foundation.dart';

class Logger {
  static String build({String? from, required dynamic text}) {
    if(from != null) {
      return "$from _______________________________ ${text.toString()}";
    } else {
      return text.toString();
    }
  }

  static void log(text, {String? from, bool needHeader = true}){
    if(kDebugMode){
      if(needHeader) {
        debugPrint("Serch Debug::: ${build(text: text, from: from)}");
      } else {
        debugPrint("Serch Debug::: ${text.toString()}");
      }
    }
  }
}

String _buildLogger({String? from, required dynamic text}) {
  if(from != null) {
    return "$from _______________________________ ${text.toString()}";
  } else {
    return text.toString();
  }
}

void log(text, {String? from, bool needHeader = true}){
  if(kDebugMode){
    if(needHeader) {
      debugPrint("Serch Debug::: ${_buildLogger(text: text, from: from)}");
    } else {
      debugPrint("Serch Debug::: ${text.toString()}");
    }
  }
}