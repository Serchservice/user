import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> authenticationRoutes = [
  GetPage(
    name: AccountIssueLayout.route,
    page: () => AccountIssueLayout(),
    binding: AccountIssueBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: EmailCheckerLayout.route,
    page: () => EmailCheckerLayout(),
    binding: EmailCheckerBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: EmailVerificationLayout.route,
    page: () => EmailVerificationLayout(),
    binding: EmailVerificationBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: LocationCheckerLayout.route,
    page: () => LocationCheckerLayout(),
    binding: LocationCheckerBinding(),
    middlewares: [
      AuthMiddleware(priority: 10)
    ],
    transition: Transition.circularReveal,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: LoginLayout.route,
    page: () => LoginLayout(),
    binding: LoginBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: OnboardingLayout.route,
    page: () => const OnboardingLayout(),
    transition: Transition.circularReveal,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: PageNotFoundLayout.route,
    page: () => const PageNotFoundLayout(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: PlatformNotSupportedLayout.route,
    page: () => const PlatformNotSupportedLayout(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordLayout.route,
    page: () => ResetPasswordLayout(),
    binding: ResetPasswordBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordConfirmationLayout.route,
    page: () => ResetPasswordConfirmationLayout(),
    binding: ResetPasswordConfirmationBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ResetPasswordRequestLayout.route,
    page: () => ResetPasswordRequestLayout(),
    binding: ResetPasswordRequestBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SignupLayout.route,
    page: () => SignupLayout(),
    binding: SignupBinding(),
    transitionDuration: const Duration(milliseconds: 800),
  ),
];