import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class RequestEntryState {
  RxString current = RxString("");

  /// Request initial category
  Rx<SerchCategory> initial = SerchCategory.empty().obs;

  /// List of SerchCategories
  RxList<SerchCategory> categories = <SerchCategory>[].obs;

  /// Selected Serch Category
  Rx<SerchCategory> selected = SerchCategory.empty().obs;

  /// Provider
  Rx<SharedUser> provider = SharedUser.empty().obs;

  /// Search data
  Rx<RequestSearch> search = RequestSearch.empty().obs;

  /// Picked address
  Rx<Address> location = Database.address.obs;

  /// Shopping items
  RxList<ShoppingItem> items = <ShoppingItem>[].obs;

  /// Total amount
  RxInt totalAmount = RxInt(0);

  /// Address for shop
  Rx<Address> shopAddress = Address.empty().obs;

  /// Show the recorder
  RxBool showRecorder = RxBool(true);

  /// Show the keyboard field
  RxBool showKeyboard = RxBool(true);

  /// Is recording
  RxBool isRecording = RxBool(false);

  /// Has paused recording
  RxBool isPausedRecording = RxBool(false);

  /// Has stopped recording
  RxBool isStoppedRecording = RxBool(false);

  /// Audio media
  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;

  /// Current recording timer
  RxInt recordingTimer = RxInt(0);

  /// Search amount
  RxString searchAmount = RxString("");
}