import 'package:get/get.dart';
import 'package:user/library.dart';

List<GetPage> guestRoutes = [
  GetPage(
    name: GuestCreateLayout.route,
    page: () => GuestCreateLayout(),
    binding: GuestCreateBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),

  GetPage(
    name: GuestHomeLayout.route,
    page: () => GuestHomeLayout(),
    binding: GuestHomeBinding(),
    transition: Transition.native,
    transitionDuration: const Duration(milliseconds: 800),
  ),
];