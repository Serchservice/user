import 'package:get/get_rx/src/rx_types/rx_types.dart';

class QuotationViewState {
  /// Is declining the quotation
  RxBool isDeclining = RxBool(false);

  /// Is accepting the quotation
  RxBool isAccepting = RxBool(false);
}