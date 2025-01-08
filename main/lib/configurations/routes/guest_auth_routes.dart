import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> guestAuthRoutes = [
  GetPage(
    name: GuestEmailConfirmationLayout.route,
    page: () => CookieConsentWrapper(child : GuestEmailConfirmationLayout()),
    binding: GuestEmailConfirmationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestEmailVerificationLayout.route,
    page: () => CookieConsentWrapper(child : GuestEmailVerificationLayout()),
    binding: GuestEmailVerificationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestLoginLayout.route,
    page: () => CookieConsentWrapper(child : GuestLoginLayout()),
    binding: GuestLoginBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestSignupLayout.route,
    page: () => CookieConsentWrapper(child : GuestSignupLayout()),
    binding: GuestSignupBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestSignupWithUserAccountLayout.route,
    page: () => CookieConsentWrapper(child : GuestSignupWithUserAccountLayout()),
    binding: GuestSignupWithUserAccountBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
  GetPage(
    name: GuestUpgradeLayout.route,
    page: () => CookieConsentWrapper(child : GuestUpgradeLayout()),
    binding: GuestUpgradeBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];