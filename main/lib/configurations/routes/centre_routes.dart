import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> centreRoutes = [
  GetPage(
    name: AppUpdatesLayout.route,
    page: () => CookieConsentWrapper(child: AppUpdatesLayout()),
    binding: AppUpdatesBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AppInformationLayout.route,
    page: () => CookieConsentWrapper(child: AppInformationLayout()),
    binding: AppInformationBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SpeakWithSerchLayout.route,
    page: () => CookieConsentWrapper(child: SpeakWithSerchLayout()),
    binding: SpeakWithSerchBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: HelpLayout.route,
    page: () => CookieConsentWrapper(child: HelpLayout()),
    binding: HelpBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PreferenceLayout.route,
    page: () => CookieConsentWrapper(child: PreferenceLayout()),
    binding: PreferenceBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletLayout.route,
    page: () => CookieConsentWrapper(child: WalletLayout()),
    binding: WalletBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletSettingsLayout.route,
    page: () => CookieConsentWrapper(child: WalletSettingsLayout()),
    binding: WalletSettingsBinding(),
    transition: Transition.downToUp,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletUpdateBankDetailsLayout.route,
    page: () => CookieConsentWrapper(child: WalletUpdateBankDetailsLayout()),
    binding: WalletUpdateBankDetailsBinding(),
    transition: Transition.circularReveal,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletTransactionsLayout.route,
    page: () => CookieConsentWrapper(child: WalletTransactionsLayout()),
    binding: WalletTransactionsBinding(),
    transition: Transition.circularReveal,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: RatingLayout.route,
    page: () => CookieConsentWrapper(child: RatingLayout()),
    binding: RatingBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PrivacyAndSecurityLayout.route,
    page: () => CookieConsentWrapper(child: PrivacyAndSecurityLayout()),
    binding: PrivacyAndSecurityBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsLayout.route,
    page: () => CookieConsentWrapper(child: BiometricsLayout()),
    binding: BiometricsBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsAuthLayout.loginRoute,
    page: () => CookieConsentWrapper(child: BiometricsAuthLayout()),
    binding: BiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsAuthLayout.route,
    page: () => CookieConsentWrapper(child: BiometricsAuthLayout()),
    binding: BiometricsAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ChangePasswordLayout.route,
    page: () => CookieConsentWrapper(child: ChangePasswordLayout()),
    binding: ChangePasswordBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MultiFactorLayout.route,
    page: () => CookieConsentWrapper(child: MultiFactorLayout()),
    binding: MultiFactorBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.loginRoute,
    page: () => CookieConsentWrapper(child: MfaAuthLayout()),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.enableRoute,
    page: () => CookieConsentWrapper(child: MfaAuthLayout()),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MfaAuthLayout.disableRoute,
    page: () => CookieConsentWrapper(child: MfaAuthLayout()),
    binding: MfaAuthBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BookmarkLayout.route,
    page: () => CookieConsentWrapper(child: BookmarkLayout()),
    binding: BookmarkBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AccountLayout.route,
    page: () => CookieConsentWrapper(child: AccountLayout()),
    binding: AccountBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AccountUpdateLayout.route,
    page: () => CookieConsentWrapper(child: AccountUpdateLayout()),
    binding: AccountUpdateBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SharedLinksLayout.route,
    page: () => CookieConsentWrapper(child: SharedLinksLayout()),
    binding: SharedLinksBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ReferralLayout.route,
    page: () => CookieConsentWrapper(child: ReferralLayout()),
    binding: ReferralBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 500),
  ),
];