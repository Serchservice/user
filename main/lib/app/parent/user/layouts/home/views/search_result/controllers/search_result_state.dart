import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class SearchResultState {
  RxDouble searchRadius = RxDouble(5000.00);

  Rx<RequestSearch> search = RequestSearch(address: Database.address).obs;

  /// Title text
  RxString title = RxString("Search Result");

  /// Current filter index
  RxInt filter = RxInt(0);

  /// Range radius
  RxDouble radius = RxDouble(5000.0);

  Rx<Active?> best = null.obs;

  RxList<SearchItem> items = <SearchItem>[].obs;

  RxList<SearchShopResponse> shops = <SearchShopResponse>[].obs;
}