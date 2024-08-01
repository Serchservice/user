import 'package:get/get_rx/get_rx.dart';
import 'package:user/library.dart';

class LocationSearchState {
  /// Is Searching for current location
  RxBool isLocationSearching = RxBool(false);

  /// List of Addresses
  RxList<Address> locations = <Address>[].obs;

  /// Picked address
  Rx<Address> location = Database.address.obs;

  /// Is Loading Search Result
  RxBool isSearching = RxBool(false);
}