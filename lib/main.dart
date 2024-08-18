import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import 'library.dart';

@pragma("vm:entry-point")
Future<void> _backgroundRemoteMessagingHandler(RemoteMessage message) async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  _initializeApp().then((v) {
    FirebaseMessagingService messaging = FirebaseMessagingImplementation();

    StreamVideo videoClient = _loadVideoClient();
    Get.put(CallConfiguration(videoClient: videoClient));

    FlutterNativeSplash.remove();
    messaging.background(message);

    StreamVideo.reset();
  });
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  _loadPlatformChannel();
  await Database.initialize();

  MainConfiguration.bind();

  Get.updateLocale(const Locale('en'));
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  final ExceptionService exceptionService = ExceptionImplementation();
  final NotificationService notification = NotificationImplementation();

  exceptionService.handleException();
  notification.init();
}

void _loadPlatformChannel() {
  const platform = MethodChannel('com.serch.user/apiKey');
  platform.setMethodCallHandler((call) async {
    if (call.method == 'getMapApiKey') {
      return Keys.googleMapApiKey;
    }
    return null;
  });
}

StreamVideo _loadVideoClient() {
  final Connect connect = Connect();

  return StreamVideo(
    Keys.streamApiKey,
    user: User(info: Database.auth.toUserInfo()),
    options: const StreamVideoOptions(
      logPriority: Priority.info,
      muteAudioWhenInBackground: true,
      muteVideoWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
        iosPushProvider: CallPushProviderSetup.iosConfig,
        androidPushProvider: CallPushProviderSetup.androidConfig,
        pushParams: CallPushProviderSetup.videoPushParams
    ),
    tokenLoader: (token) async {
      final ApiResponse response = await connect.get(endpoint: "/call/authentication");
      if(response.isSuccessful) {
        return response.data;
      } else {
        return "";
      }
    },
    onTokenUpdated: (token) async {},
  );
}

@pragma('vm:entry-point')
Future<void> backgroundCallHandler() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  _initializeApp().then((v) {
    StreamVideo videoClient = _loadVideoClient();
    FlutterNativeSplash.remove();
    Get.put(CallConfiguration(videoClient: videoClient));
  });
}

extension on AuthResponse {
  UserInfo toUserInfo() {
    return UserInfo(
      id: id,
      role: role,
      name: name,
      image: avatar,
    );
  }
}

Future<void> main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_backgroundRemoteMessagingHandler);
  _initializeApp().then((v) => runApp(const Main()));
}