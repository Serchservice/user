import 'package:get/get.dart';
import 'package:user/library.dart';

class CallChannelController extends GetxController {
  final CallResponse call;

  CallChannelController({required this.call});
  final state = CallChannelState();

  @override
  void onInit() {
    state.call.value = call;

    super.onInit();
  }
}