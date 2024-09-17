import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'library.dart';

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const App(initialRoute: LocationCheckerLayout.route);
  }
}

class NotificationMain extends StatelessWidget {
  const NotificationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const App(initialRoute: HomeLayout.route);
  }
}

class App extends StatelessWidget {
  final String initialRoute;
  const App({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ScreenUtilInit(
        designSize: const Size(360, 760),
        minTextAdapt: true,
        splitScreenMode: true,
        child: RefreshConfiguration(
          headerBuilder: () => const WaterDropHeader(),
          footerBuilder:  () => const ClassicFooter(),
          headerTriggerDistance: 80.0,
          springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
          maxOverScrollExtent :100,
          maxUnderScrollExtent:0,
          enableScrollWhenRefreshCompleted: true,
          enableLoadingWhenFailed : true,
          hideFooterWhenNotFull: false,
          enableBallisticLoad: true,
          child: GetMaterialApp(
            navigatorKey: Navigate.navigatorKey,
            defaultTransition: Transition.fade,
            theme: MainTheme.light,
            darkTheme: MainTheme.dark,
            themeMode: Database.themeMode,
            title: "Serch",
            color: CommonColors.darkTheme,
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            unknownRoute: GetPage(
              name: PageNotFoundLayout.route,
              page: () => const PageNotFoundLayout(),
              transition: Transition.size,
              transitionDuration: const Duration(milliseconds: 500),
            ),
            useInheritedMediaQuery: true,
            getPages: Routes.all,
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
      ),
    );
  }
}