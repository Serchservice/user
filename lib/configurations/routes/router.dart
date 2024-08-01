import 'package:get/get.dart';
import 'package:user/library.dart';

class Routes {
  static List<GetPage> all = [
    ...authenticationRoutes,
    ...centreRoutes,
    ...guestRoutes,
    ...homeRoutes,
    ...conversationRoutes,

    GetPage(
      name: HomeLayout.route,
      page: () => HomeLayout(),
      binding: HomeBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: WebLayout.route,
      page: () => const WebLayout(),
      binding: WebBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: ReferralLinkVerifierLayout.route,
      page: () => ReferralLinkVerifierLayout(),
      binding: ReferralLinkVerifierBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: SharedLinkVerifierLayout.route,
      page: () => SharedLinkVerifierLayout(),
      binding: SharedLinkVerifierBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: CameraLayout.route,
      page: () => CameraLayout(),
      binding: CameraBinding(),
      transition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
    ),

    GetPage(
      name: GalleryLayout.route,
      page: () => GalleryLayout(),
      binding: GalleryBinding(),
      transition: Transition.downToUp,
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