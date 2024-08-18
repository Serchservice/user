import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'library.dart';

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final AppService _appService = AppImplementation();
  final AccessService _accessService = AccessImplementation();

  @override
  void initState() {
    _appService.buildDeviceInformation(onSuccess: (device) {
      Database.initialize().then((v) => Database.saveDevice(device));
      _requestAccess(device.sdk);
    });
    super.initState();
  }

  Future<void> _requestAccess(int sdk) async {
    bool hasAccess = await _accessService.requestPermissions(sdk);
    if(hasAccess) {
      if(GetPlatform.isMobile || GetPlatform.isIOS) {
        return;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      _requestAccess(sdk);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(360, 760),
        minTextAdapt: true,
        splitScreenMode: true,
        child: GetMaterialApp(
          navigatorKey: Navigate.navigatorKey,
          defaultTransition: Transition.fade,
          theme: MainTheme.light,
          darkTheme: MainTheme.dark,
          themeMode: Database.themeMode,
          title: "Serch",
          color: CommonColors.darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: LocationCheckerLayout.route,
          unknownRoute: GetPage(
            name: PageNotFoundLayout.route,
            page: () => const PageNotFoundLayout(),
            transition: Transition.size,
            transitionDuration: const Duration(milliseconds: 500),
          ),
          useInheritedMediaQuery: true,
          getPages: Routes.all,
          // initialRoute: LocationCheckerLayout.route,
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
      ),
    );
  }
}