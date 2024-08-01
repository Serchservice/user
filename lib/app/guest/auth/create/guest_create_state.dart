import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class GuestCreateState {
  /// Is saving the profile
  RxBool isSaving = false.obs;

  /// Selected Gender
  RxString gender = "".obs;

  /// Link
  RxString link = "".obs;

  /// LinkId
  RxString linkId = "".obs;

  /// Upload
  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;

  /// Avatar
  RxString avatar = "".obs;
}