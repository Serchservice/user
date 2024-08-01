import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class SkillSearchState {
  /// List of Specializations
  RxList<Specialization> specializations = <Specialization>[].obs;

  /// Selected specialization
  Rx<Specialization> specialization = Specialization.empty().obs;

  /// Selected selectedCategory
  Rx<SerchCategory> category = SerchCategory.empty().obs;

  /// Is Loading Search Result
  RxBool isSearching = RxBool(false);

  /// Is Searching for current location
  RxBool isLocationSearching = RxBool(false);

  /// List of Addresses
  RxList<Address> locations = <Address>[].obs;

  /// Picked address
  Rx<Address> location = Database.address.obs;
}