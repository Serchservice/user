import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestHomeState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Timeout count
  RxInt timeout = 59.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  /// First name
  RxString firstName = RxString(Database.guest.firstName);

  /// Full name
  RxString name = RxString(Database.guest.name);

  /// Category image
  RxString image = RxString(Database.guest.avatar);

  /// Avatar
  RxString avatar = RxString(Database.guest.avatar);

  /// Current preference
  Rx<Preference> preference = Database.preference.obs;

  /// Guest profile
  Rx<Guest> guest = Database.guest.obs;

  /// Become a user
  RxBool isLoading = RxBool(false);

  /// Is fetching invites
  RxBool isFetchingTripInvites = RxBool(true);

  /// List of trip invites
  RxList<TripResponse> invites = <TripResponse>[].obs;

  /// Is fetching invites
  RxBool isFetchingTrips = RxBool(true);

  /// List of trips
  RxList<TripResponse> trips = <TripResponse>[].obs;

  /// List of trip history
  RxList<TripResponse> history = <TripResponse>[].obs;

  /// List of active trips
  RxList<TripResponse> actives = <TripResponse>[].obs;

  /// List of active events
  RxList<ActiveEvent> events = RxList([]);
}