import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> authenticationRoutes = [
  GetPage(
    name: OnboardingLayout.route,
    page: () => CookieConsentWrapper(child: const OnboardingLayout()),
    transition: Transition.circularReveal,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SharedLinkVerifierLayout.route,
    page: () => CookieConsentWrapper(child: SharedLinkVerifierLayout()),
    binding: SharedLinkVerifierBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ReferralLinkVerifierLayout.route,
    page: () => CookieConsentWrapper(child: ReferralLinkVerifierLayout()),
    binding: ReferralLinkVerifierBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: EmailCheckerLayout.route,
    page: () => CookieConsentWrapper(child: EmailCheckerLayout()),
    binding: EmailCheckerBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: EmailSwitchLayout.route,
    page: () => CookieConsentWrapper(child: EmailSwitchLayout()),
    binding: EmailSwitchBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: EmailVerificationLayout.route,
    page: () => CookieConsentWrapper(child: EmailVerificationLayout()),
    binding: EmailVerificationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: LoginLayout.route,
    page: () => CookieConsentWrapper(child: LoginLayout()),
    binding: LoginBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordLayout.route,
    page: () => CookieConsentWrapper(child: ResetPasswordLayout()),
    binding: ResetPasswordBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordConfirmationLayout.route,
    page: () => CookieConsentWrapper(child: ResetPasswordConfirmationLayout()),
    binding: ResetPasswordConfirmationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordRequestLayout.route,
    page: () => CookieConsentWrapper(child: ResetPasswordRequestLayout()),
    binding: ResetPasswordRequestBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SignupLayout.route,
    page: () => CookieConsentWrapper(child: SignupLayout()),
    binding: SignupBinding(),
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];