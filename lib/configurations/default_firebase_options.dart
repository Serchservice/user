import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:user/library.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: Keys.firebaseWebApiKey,
    appId: Keys.firebaseWebAppId,
    messagingSenderId: Keys.firebaseMessagingSenderId,
    projectId: Keys.firebaseProjectId,
    authDomain: Keys.firebaseAuthDomain,
    storageBucket: Keys.firebaseStorageBucket,
    measurementId: 'G-2WZ9SG67RF',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: Keys.firebaseAndroidApiKey,
    appId: Keys.firebaseAndroidAppId,
    messagingSenderId: Keys.firebaseMessagingSenderId,
    projectId: Keys.firebaseProjectId,
    storageBucket: Keys.firebaseStorageBucket,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: Keys.firebaseIosMacosApiKey,
    appId: Keys.firebaseIosAppId,
    messagingSenderId: Keys.firebaseMessagingSenderId,
    projectId: Keys.firebaseProjectId,
    storageBucket: Keys.firebaseStorageBucket,
    iosBundleId: 'serch.user.app',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: Keys.firebaseIosMacosApiKey,
    appId: Keys.firebaseMacosAppId,
    messagingSenderId: Keys.firebaseMessagingSenderId,
    projectId: Keys.firebaseProjectId,
    storageBucket: Keys.firebaseStorageBucket,
    iosBundleId: 'com.serch.user.RunnerTests',
  );
}