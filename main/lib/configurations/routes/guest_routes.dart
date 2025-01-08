import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> guestRoutes = [
  GetPage(
    name: GuestParentLayout.route,
    page: () => CookieConsentWrapper(child: GuestParentLayout()),
    binding: GuestParentBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestAccountLayout.route,
    page: () => CookieConsentWrapper(child: GuestAccountLayout()),
    binding: GuestAccountBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestPreferenceLayout.route,
    page: () => CookieConsentWrapper(child: GuestPreferenceLayout()),
    binding: GuestPreferenceBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestPrivacyAndSecurityLayout.route,
    page: () => CookieConsentWrapper(child: GuestPrivacyAndSecurityLayout()),
    binding: GuestPrivacyAndSecurityBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: GuestBiometricsLayout.route,
    page: () => CookieConsentWrapper(child: GuestBiometricsLayout()),
    binding: GuestBiometricsBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: GuestBiometricsAuthLayout.loginRoute,
    page: () => CookieConsentWrapper(child: GuestBiometricsAuthLayout()),
    binding: GuestBiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: GuestBiometricsAuthLayout.route,
    page: () => CookieConsentWrapper(child: GuestBiometricsAuthLayout()),
    binding: GuestBiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),
];