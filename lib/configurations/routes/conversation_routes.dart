import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> conversationRoutes = [
  GetPage(
    name: CallLayout.route,
    page: () => CallLayout(),
    binding: CallBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ChatLayout.route,
    page: () => ChatLayout(),
    binding: ChatBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware(priority: 20)
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];