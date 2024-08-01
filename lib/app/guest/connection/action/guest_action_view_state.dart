import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class GuestActionViewState {
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

  /// Is playing
  RxBool isPlaying = RxBool(false);

  /// Audio media
  Rx<SelectedMedia> media = SelectedMedia(path: "").obs;

  /// Current recording timer
  RxInt recordingTimer = RxInt(0);

  /// Current position
  RxDouble currentPosition = RxDouble(0.0);

  /// Total duration
  RxDouble totalDuration = RxDouble(0.0);
}