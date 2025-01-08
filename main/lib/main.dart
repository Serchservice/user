import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:notify_flutter/notify_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'library.dart';

@pragma("vm:entry-point")
Future<void> _backgroundRemoteMessagingHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  _initializeApp().then((_) {
    FirebaseMessagingService messaging = FirebaseMessagingImplementation();
    messaging.background(message);

    StreamVideo videoClient = loadVideoClient();
    _run();

    if(NotifyTypeChecker.instance.isCall(message.data)) {
      Get.put(CallConfiguration(
        videoClient: videoClient,
        notification: NotifyTypeBuilder.instance.call(message.data),
        from: message.from
      ));
    } else {
      Get.put(CallConfiguration(videoClient: videoClient));
    }
  });
}

@pragma('vm:entry-point')
Future<void> backgroundCallHandler() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);
  _initializeApp().then((v) {
    StreamVideo videoClient = loadVideoClient();
    Get.put(CallConfiguration(videoClient: videoClient));
  });
}

Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");
  _loadPlatformChannel();
  Get.updateLocale(const Locale('en'));

  return await Database.initialize();
}

void _loadPlatformChannel() {
  const platform = MethodChannel('com.serchservice.user/apiKey');
  platform.setMethodCallHandler((call) async {
    if (call.method == 'getMapApiKey') {
      return Keys.googleMapApiKey;
    }
    return null;
  });
}

StreamVideo loadVideoClient() {
  final Connect connect = Connect();

  return StreamVideo(
    Keys.streamApiKey,
    user: User(info: Database.auth.toUserInfo()),
    options: const StreamVideoOptions(
      logPriority: Priority.none,
      muteAudioWhenInBackground: true,
      muteVideoWhenInBackground: true,
    ),
    // pushNotificationManagerProvider: CallPushProviderSetup.manager,
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

Future<void> launchDevice() async {
  final AppService appService = AppImplementation();
  final AccessService accessService = AccessImplementation();

  appService.buildDeviceInformation(onSuccess: (device) async {
    Database.saveDevice(device);
    if(!Database.preference.hasGrantedPermissions || !await accessService.hasLocation()) {
      PermissionSheet.open(sdk: device.sdk);
    }

    AnalyticsEngine.logEvent("DEVICE_INFORMATION", parameters: device.toJson());
  });

  appService.getCountries(
    onSuccess: (result) {
      if(result.isNotEmpty) {
        MainConfiguration.data.countries.value = result;
        Database.saveCountries(result);
      }
    }
  );
}

bool isCurrentRoute(String route) => Get.currentRoute == route;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  FirebaseMessaging.onBackgroundMessage(_backgroundRemoteMessagingHandler);

  _initializeApp().then((v) => _run());
}

void _run() {
  MainConfiguration.bind();

  usePathUrlStrategy();
  runApp(const Main());
}