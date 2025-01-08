import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> connectRoutes = [
  GetPage(
    name: CallLayout.route,
    page: () => CookieConsentWrapper(child: CallLayout()),
    binding: CallBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: ChatRoomLayout.route,
    page: () => CookieConsentWrapper(child: ChatRoomLayout()),
    binding: ChatRoomBinding(),
    transition: Transition.native,
    middlewares: [
      DeviceMiddleware()
    ],
    transitionDuration: const Duration(milliseconds: 800),
  ),
];