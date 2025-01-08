import 'package:user/library.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  RatingController();
  final state = RatingState();

  List<ButtonView> tabs = [
    ButtonView(header: "Overview"),
    ButtonView(header: "Good Reviews"),
    ButtonView(header: "Bad Reviews"),
  ];
}