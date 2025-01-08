import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:user/library.dart';

class Keys {
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

  /// Map Box Api Key
  static final String mapbox = dotenv.env["MAPBOX_API_KEY"] ?? "";

  /// Google map api key
  static String get googleMapApiKey {
    if(PlatformEngine.instance.isAndroid) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_ANDROID"] ?? "";
    } else if(PlatformEngine.instance.isIOS) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_IOS"] ?? "";
    } else if(PlatformEngine.instance.isWeb) {
      return dotenv.env["GOOGLE_MAPS_API_KEY_WEB"] ?? "";
    } else {
      return "";
    }
  }
}