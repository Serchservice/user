import 'package:get/get.dart';
import 'package:user/library.dart';

class Routes {
  static List<GetPage> all = [
    ...authenticationRoutes,

    GetPage(
      name: HomeLayout.route,
      page: () => const HomeLayout(),
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
  ];
}