import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'library.dart';

Future<void> backgroundHandler(RemoteMessage remoteMessage) async {
  RemoteMessagingService messaging = RemoteMessagingImplementation();
  messaging.backgroundHandler();
}

Future<void> main() async {
  AppService service = AppImplementation();
  service.start();
  Get.put<AppConfiguration>(AppConfiguration());
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.fade,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: Database.themeMode,
      title: "Serch",
      color: CommonColors.darkTheme,
      debugShowCheckedModeBanner: false,
      unknownRoute: GetPage(
        name: PageNotFoundLayout.route,
        page: () => const PageNotFoundLayout(),
        transition: Transition.size,
        transitionDuration: const Duration(milliseconds: 500),
      ),
      // builder: InAppNotification.init(),
      useInheritedMediaQuery: true,
      getPages: Routes.all,
      initialRoute: LocationCheckerLayout.route,
      routingCallback: (value) {
        Logger.log(value?.route);
      }
    );
  }
}