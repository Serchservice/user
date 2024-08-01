import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'library.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  FirebaseMessagingService messaging = FirebaseMessagingImplementation();
  messaging.background(message);
}

final ExceptionService _exceptionService = ExceptionImplementation();
final NotificationService _notification = NotificationImplementation();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: FirebaseConfiguration.currentPlatform);

  await Database.initialize();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top,
    ]
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  Get.put<MainConfiguration>(MainConfiguration());

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  _exceptionService.handleException();
  _notification.init();
  Get.updateLocale(const Locale('en'));

  runApp(const Main());
}

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        navigatorKey: Navigate.navigatorKey,
        defaultTransition: Transition.fade,
        theme: MainTheme.light,
        darkTheme: MainTheme.dark,
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
        useInheritedMediaQuery: true,
        getPages: Routes.all,
        initialRoute: LocationCheckerLayout.route,
        routingCallback: MainConfiguration.data.updateRoute,
        builder: (context, child) {
          return ToastificationConfigProvider(
            config: const ToastificationConfig(
              alignment: Alignment.center,
              animationDuration: Duration(milliseconds: 500),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}