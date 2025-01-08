import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AccountUpdateState {
  RxString avatar = RxString("");

  RxString countryCode = RxString("");

  RxString isoCode = RxString("");

  Rx<Gender> gender = Gender.none.obs;

  Rx<Country> country = Country.primary().obs;

  RxBool isLoading = RxBool(false);

  Rx<SelectedMedia> selectedAvatar = SelectedMedia(path: "").obs;
}