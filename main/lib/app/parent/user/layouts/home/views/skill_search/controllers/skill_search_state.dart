import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:user/library.dart';

class SkillSearchState {
  RxString query = RxString("");

  /// Selected specialization
  Rx<Specialization> specialization = Specialization.empty().obs;

  /// Selected selectedCategory
  Rx<SerchCategory> category = SerchCategory.empty().obs;

  /// Picked address
  Rx<Address> location = Database.address.obs;
}