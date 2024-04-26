import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static final String firebaseWebApiKey = dotenv.env["FIREBASE_WEB_API_KEY"] ?? "";

  static final String firebaseWebAppId = dotenv.env["FIREBASE_WEB_APP_ID"] ?? "";

  static final String firebaseAndroidApiKey = dotenv.env["FIREBASE_ANDROID_API_KEY"] ?? "";

  static final String firebaseAndroidAppId = dotenv.env["FIREBASE_ANDROID_APP_ID"] ?? "";

  static final String firebaseIosMacosApiKey = dotenv.env["FIREBASE_IOS_MACOS_API_KEY"] ?? "";

  static final String firebaseMacosAppId = dotenv.env["FIREBASE_MACOS_APP_ID"] ?? "";

  static final String firebaseIosAppId = dotenv.env["FIREBASE_IOS_APP_ID"] ?? "";

  static final String firebaseMessagingSenderId = dotenv.env["FIREBASE_MESSAGING_SENDER_ID"] ?? "";

  static final String firebaseProjectId = dotenv.env["FIREBASE_PROJECT_ID"] ?? "";

  static final String firebaseAuthDomain = dotenv.env["FIREBASE_AUTH_DOMAIN"] ?? "";

  static final String firebaseStorageBucket = dotenv.env["FIREBASE_STORAGE_BUCKET"] ?? "";

  static final String baseUrl = dotenv.env["BASE_URL"] ?? "";

  static final String supabaseKey = dotenv.env["SUPABASE_KEY"] ?? "";
}