import 'package:user/library.dart';
import 'package:get/get.dart';

List<GetPage> miscRoutes = [
  GetPage(
    name: AccountIssueLayout.route,
    page: () => CookieConsentWrapper(child: AccountIssueLayout()),
    binding: AccountIssueBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: AccountPickerLayout.route,
    page: () => CookieConsentWrapper(child: AccountPickerLayout()),
    binding: AccountPickerBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: PageNotFoundLayout.route,
    page: () => CookieConsentWrapper(child: const PageNotFoundLayout()),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: PlatformErrorLayout.route,
    page: () => CookieConsentWrapper(child: PlatformErrorLayout()),
    binding: PlatformErrorBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: WebLayout.route,
    page: () => CookieConsentWrapper(child: const WebLayout()),
    binding: WebBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];