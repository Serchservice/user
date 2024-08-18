import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  /// Serchservice base url
  static final String baseUrl = dotenv.env["BASE_URL"] ?? "";

  /// Get stream api key
  static final String streamApiKey = dotenv.env["GET_STREAM_API_KEY"] ?? "";

  /// Google map api key
  static String get googleMapApiKey {
    if(Platform.isAndroid) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_ANDROID"] ?? "";
    } else if(Platform.isIOS) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_IOS"] ?? "";
    } else {
      return "";
    }
  }
}