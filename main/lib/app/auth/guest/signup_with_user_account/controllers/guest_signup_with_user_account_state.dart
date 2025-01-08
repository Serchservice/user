import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class GuestSignupWithUserAccountState {
  RxString link = RxString("");

  RxBool isVisible = RxBool(false);

  RxBool isVerifying = RxBool(false);

  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;

  RxString avatar = "".obs;
}