import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class ActiveResultState {
  /// Is Searching
  RxBool isSearching = RxBool(true);

  /// Specialization (For Skill Search)
  Rx<RequestSearch> searchQuery = RequestSearch(address: Database.address).obs;

  /// Title text
  RxString title = RxString("Search Result");

  /// Current filter index
  RxInt filter = RxInt(0);

  /// Range radius
  RxDouble radius = RxDouble(5000.0);

  /// Search response
  Rx<SearchResponse> search = SearchResponse.empty().obs;

  /// List of sorted provider list
  RxList<Active> sortedProviders = <Active>[].obs;

  /// List of shop search
  RxList<SearchShopResponse> shops = <SearchShopResponse>[].obs;

  /// List of sorted shop search
  RxList<SearchShopResponse> sortedShops = <SearchShopResponse>[].obs;

  /// Mixed skill search list
  RxList<dynamic> skillSearchList = <dynamic>[].obs;
}