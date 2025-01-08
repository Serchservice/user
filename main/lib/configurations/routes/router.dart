import 'package:get/get.dart';
import 'package:user/library.dart';

class Routes {
  static List<GetPage> all = [
    ...authenticationRoutes,
    ...centreRoutes,
    ...guestRoutes,
    ...homeRoutes,
    ...connectRoutes,
    ...guestAuthRoutes,
    ...miscRoutes,

    GetPage(
      name: ParentLayout.route,
      page: () => CookieConsentWrapper(child: ParentLayout()),
      binding: ParentBinding(),
      transition: Transition.circularReveal,
      middlewares: [
        AuthMiddleware(priority: 10),
        DeviceMiddleware()
      ],
      transitionDuration: const Duration(milliseconds: 800),
    ),


    GetPage(
      name: CameraLayout.route,
      page: () => CookieConsentWrapper(child: CameraLayout()),
      binding: CameraBinding(),
      transition: Transition.native,
      middlewares: [
      DeviceMiddleware()
    ],
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: GalleryLayout.route,
      page: () => CookieConsentWrapper(child: GalleryLayout()),
      binding: GalleryBinding(),
      transition: Transition.downToUp,
      middlewares: [
        DeviceMiddleware()
      ],
      transitionDuration: const Duration(milliseconds: 800),
    ),
  ];
}

void redirect({String message = "Unformatted email address", String? page}) async {
  if(page != null) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigate.offTo(page);
    });
  } else {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigate.back();
    });
  }
  notify.error(message: message);
}