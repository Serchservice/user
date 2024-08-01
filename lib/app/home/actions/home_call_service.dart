import 'package:user/library.dart';

abstract class HomeCallService {
  void fetchCalls({bool showLoader = true});

  List<ButtonView> get filters;
}