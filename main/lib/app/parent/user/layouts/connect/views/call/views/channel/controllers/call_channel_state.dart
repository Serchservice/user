import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class CallChannelState {
  Rx<CallResponse> call = CallResponse.empty().obs;
}