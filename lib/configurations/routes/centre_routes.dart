import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> centreRoutes = [
  GetPage(
    name: AppUpdatesLayout.route,
    page: () => AppUpdatesLayout(),
    binding: AppUpdatesBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AppInformationLayout.route,
    page: () => AppInformationLayout(),
    binding: AppInformationBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SpeakWithSerchLayout.route,
    page: () => SpeakWithSerchLayout(),
    binding: SpeakWithSerchBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: HelpLayout.route,
    page: () => HelpLayout(),
    binding: HelpBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PreferenceLayout.route,
    page: () => PreferenceLayout(),
    binding: PreferenceBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: WalletLayout.route,
    page: () => WalletLayout(),
    binding: WalletBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: TransactionLayout.route,
    page: () => TransactionLayout(),
    binding: TransactionBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: RatingLayout.route,
    page: () => RatingLayout(),
    binding: RatingBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: PrivacyAndSecurityLayout.route,
    page: () => PrivacyAndSecurityLayout(),
    binding: PrivacyAndSecurityBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BiometricsLayout.route,
    page: () => BiometricsLayout(),
    binding: BiometricsBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ChangePasswordLayout.route,
    page: () => ChangePasswordLayout(),
    binding: ChangePasswordBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: MultiFactorLayout.route,
    page: () => MultiFactorLayout(),
    binding: MultiFactorBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: BookmarkLayout.route,
    page: () => BookmarkLayout(),
    binding: BookmarkBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: AccountLayout.route,
    page: () => AccountLayout(),
    binding: AccountBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: SharedLinksLayout.route,
    page: () => SharedLinksLayout(),
    binding: SharedLinksBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),

  GetPage(
    name: ReferralLayout.route,
    page: () => ReferralLayout(),
    binding: ReferralBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 500),
  ),
];