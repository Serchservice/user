import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SpeakWithSerchTicketState {
  RxBool isSending = RxBool(false);

  RxBool showSendButton = RxBool(false);

  RxBool showScrollButton = false.obs;

  Rx<SpeakWithSerch> message = SpeakWithSerch.empty().obs;

  RxInt nextPage = RxInt(0);

  RxString error = RxString("");

  RxBool isLastPage = RxBool(false);

  RxBool isLoadingMore = RxBool(false);

  RxBool isFetching = RxBool(false);
}