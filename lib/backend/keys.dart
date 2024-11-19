import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  /// Serchservice base url
  static final String baseUrl = dotenv.env["BASE_URL"] ?? "";

  /// Tip2Fix Session Duration
  static final int tip2fixSession = int.parse(dotenv.env["TIP2FIX_SESSION"] ?? "30");

  /// Serch signature
  static final String signature = dotenv.env["SIGNATURE"] ?? "";

  /// Serch guest api key
  static final String guestApiKey = dotenv.env["GUEST_API_KEY"] ?? "";

  /// Serch guest secret key
  static final String guestSecretKey = dotenv.env["GUEST_SECRET_KEY"] ?? "";

  /// Get stream api key
  static final String streamApiKey = dotenv.env["GET_STREAM_API_KEY"] ?? "";

  /// Google play store id for the Serch App - [ANDROID]
  static final String googlePlay = dotenv.env["SERCH_ANDROID_STORE_ID"] ?? "";

  /// App store id for the Serch App - [iOS]
  static final String appStore = dotenv.env["SERCH_IOS_STORE_ID"] ?? "";

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