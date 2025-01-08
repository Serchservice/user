import 'package:user/library.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeState {
  RxBool isLoading = RxBool(true);

  Rx<Dashboard> dashboard = Dashboard.empty().obs;

  /// List of SerchCategories
  RxList<SerchCategory> categories = <SerchCategory>[].obs;

  /// List of Popular SerchCategories
  RxList<SerchCategory> popularCategories = <SerchCategory>[].obs;

  /// Is fetching categories
  RxBool isFetchingCategories = RxBool(true);

  /// Is fetching popular categories
  RxBool isFetchingPopularCategories = RxBool(true);
}