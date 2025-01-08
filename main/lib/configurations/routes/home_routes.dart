import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> homeRoutes = [
  GetPage(
    name: RequestEntryLayout.route,
    page: () => CookieConsentWrapper(child: RequestEntryLayout()),
    binding: RequestEntryBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SkillSearchLayout.route,
    page: () => CookieConsentWrapper(child: SkillSearchLayout()),
    binding: SkillSearchBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SearchResultLayout.route,
    page: () => CookieConsentWrapper(child: SearchResultLayout()),
    binding: SearchResultBinding(),
    transition: Transition.downToUp,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];