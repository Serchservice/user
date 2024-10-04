import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> homeRoutes = [
  GetPage(
    name: ActiveResultLayout.route,
    page: () => ActiveResultLayout(),
    binding: ActiveResultBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: SkillSearchLayout.route,
    page: () => SkillSearchLayout(),
    binding: SkillSearchBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: RequestActionLayout.route,
    page: () => RequestActionLayout(),
    binding: RequestActionBinding(),
    transition: Transition.downToUp,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];