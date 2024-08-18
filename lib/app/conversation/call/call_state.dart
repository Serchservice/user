import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class CallState {
  /// Call Response
  Rx<ActiveCallResponse> call = ActiveCallResponse.empty().obs;

  /// Current duration
  RxString duration = RxString("");

  /// Current session
  RxInt session = RxInt(0);

  /// Search request data
  Rx<RequestSearch> search = RequestSearch(address: Database.address).obs;

  RxString amount = RxString("");

  /// Call speaker on volume out
  RxBool isOnSpeaker = RxBool(false);

  /// Microphone is muted
  RxBool isAudioMuted = RxBool(false);

  /// Checks if Agora Engine is initialized
  RxBool isInitialized = RxBool(false);

  /// Checks if the user has decided to invite the provider
  RxBool isInviting = RxBool(false);

  /// The wallet data
  Rx<Wallet> wallet = Wallet.empty().obs;

  // Fetching wallet details
  RxBool isFetchingWallet = RxBool(true);
}