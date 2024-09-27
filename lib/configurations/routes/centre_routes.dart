import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> centreRoutes = [
  GetPage(
    name: AppUpdatesLayout.route,
    page: () => AppUpdatesLayout(),
    binding: AppUpdatesBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AppInformationLayout.route,
    page: () => AppInformationLayout(),
    binding: AppInformationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SpeakWithSerchLayout.route,
    page: () => SpeakWithSerchLayout(),
    binding: SpeakWithSerchBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: HelpLayout.route,
    page: () => HelpLayout(),
    binding: HelpBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PreferenceLayout.route,
    page: () => PreferenceLayout(),
    binding: PreferenceBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletLayout.route,
    page: () => WalletLayout(),
    binding: WalletBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletSettingsLayout.route,
    page: () => WalletSettingsLayout(),
    binding: WalletSettingsBinding(),
    transition: Transition.downToUp,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: UpdateBankDetailsLayout.route,
    page: () => UpdateBankDetailsLayout(),
    binding: UpdateBankDetailsBinding(),
    transition: Transition.circularReveal,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: RatingLayout.route,
    page: () => RatingLayout(),
    binding: RatingBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PrivacyAndSecurityLayout.route,
    page: () => PrivacyAndSecurityLayout(),
    binding: PrivacyAndSecurityBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsLayout.route,
    page: () => BiometricsLayout(),
    binding: BiometricsBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsAuthLayout.loginRoute,
    page: () => BiometricsAuthLayout(),
    binding: BiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsAuthLayout.route,
    page: () => BiometricsAuthLayout(),
    binding: BiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ChangePasswordLayout.route,
    page: () => ChangePasswordLayout(),
    binding: ChangePasswordBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MultiFactorLayout.route,
    page: () => MultiFactorLayout(),
    binding: MultiFactorBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.loginRoute,
    page: () => MfaAuthLayout(),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.enableRoute,
    page: () => MfaAuthLayout(),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.disableRoute,
    page: () => MfaAuthLayout(),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BookmarkLayout.route,
    page: () => BookmarkLayout(),
    binding: BookmarkBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AccountLayout.route,
    page: () => AccountLayout(),
    binding: AccountBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SharedLinksLayout.route,
    page: () => SharedLinksLayout(),
    binding: SharedLinksBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ReferralLayout.route,
    page: () => ReferralLayout(),
    binding: ReferralBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),
];