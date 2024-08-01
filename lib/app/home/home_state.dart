import 'package:get/get.dart';
import 'package:user/library.dart';

class HomeState {
  /// Current Index of the navigator
  RxInt routeIndex = 0.obs;

  /// Timeout count
  RxInt timeout = 59.obs;

  /// Current theme mode
  Rx<ThemeType> theme = Database.preference.theme.obs;

  /// First name
  RxString firstName = RxString(Database.auth.firstName);

  /// Full name
  RxString name = RxString(Database.auth.name);

  /// Rating
  RxDouble rating = RxDouble(Database.auth.rating);

  /// Category image
  RxString image = RxString(Database.auth.image);

  /// Avatar
  RxString avatar = RxString(Database.auth.avatar);

  /// Is fetching
  RxBool isFetchingSharedLinks = RxBool(true);

  /// List of SharedLinks
  RxList<SharedLink> sharedLinks = <SharedLink>[].obs;

  /// List of active events
  RxList<ActiveEvent> events = RxList([]);

  /// Has Unread message from Speak with Serch
  RxBool hasSerchMessage = RxBool(true);

  /// List of SpeakWithSerch Messages
  RxList<SpeakWithSerch> speakWithSerch = <SpeakWithSerch>[].obs;

  /// List of SerchCategories
  RxList<SerchCategory> categories = <SerchCategory>[].obs;

  /// List of Popular SerchCategories
  RxList<SerchCategory> popularCategories = <SerchCategory>[].obs;

  /// Is fetching categories
  RxBool isFetchingCategories = RxBool(true);

  /// Is fetching popular categories
  RxBool isFetchingPopularCategories = RxBool(true);

  /// Dashboard Details
  Rx<Dashboard> dashboard = Dashboard.empty().obs;

  /// Fetching dashboard
  RxBool isFetchingDashboard = RxBool(true);

  /// Current chat filter index
  RxInt currentChatFilter = RxInt(0);

  /// Current call filter index
  RxInt currentCallFilter = RxInt(0);

  /// Is fetching chats
  RxBool isFetchingChats = RxBool(true);

  /// List of chat room sockets
  RxList<Socket> sockets = <Socket>[].obs;

  /// List of chats
  RxList<ChatRoom> chats = <ChatRoom>[].obs;

  /// List of filtered chats
  RxList<ChatRoom> filteredChats = <ChatRoom>[].obs;

  /// List of subscribed rooms
  RxSet<String> subscribed = RxSet<String>();

  /// Is fetching calls
  RxBool isFetchingCalls = RxBool(true);

  /// List of calls
  RxList<Call> calls = <Call>[].obs;

  /// List of filtered calls
  RxList<Call> filteredCalls = <Call>[].obs;

  /// Current active filter index
  RxInt activeActivityFilter = RxInt(0);

  /// Current request filter index
  RxInt requestActivityFilter = RxInt(0);

  /// Current history filter index
  RxInt historyActivityFilter = RxInt(0);

  /// Is fetching schedules
  RxBool isFetchingSchedules = RxBool(true);

  /// Current schedule filter index
  RxInt historyScheduleFilter = RxInt(0);

  /// Current schedule category filter index
  RxInt historyScheduleCategoryFilter = RxInt(0);

  /// List of all schedules
  RxList<ScheduleGroup> scheduleHistory = <ScheduleGroup>[].obs;

  /// List of all filtered schedules
  RxList<ScheduleGroup> filteredHistorySchedules = <ScheduleGroup>[].obs;

  /// Selected filter date formatted
  Rx<DateTime> selectedScheduleHistoryFilterDate = DateTime(2009).obs;

  /// Selected filter category status
  RxString selectedScheduleHistoryFilterCategory = RxString("");

  /// Selected filter status
  RxString selectedScheduleHistoryFilterStatus = RxString("");

  /// List of active or requested schedules
  RxList<Schedule> schedules = <Schedule>[].obs;

  /// Current active filter index
  RxString activeScheduleFilterCategory = RxString("");

  /// Current active category filter index
  RxInt activeScheduleCategoryFilter = RxInt(0);

  /// List of active schedules
  RxList<Schedule> filteredActiveSchedules = <Schedule>[].obs;

  /// Current requested category filter index
  RxInt requestedScheduleCategoryFilter = RxInt(0);

  /// Current requested filter index
  RxString requestedScheduleFilterCategory = RxString("");

  /// List of active schedules
  RxList<Schedule> filteredRequestedSchedules = <Schedule>[].obs;

  /// Is fetching invites
  RxBool isFetchingTripInvites = RxBool(true);

  /// List of trip invites
  RxList<TripResponse> invites = <TripResponse>[].obs;

  /// Current trip category filter index
  RxInt inviteTripCategoryFilter = RxInt(0);

  /// Current invite filter index
  RxString inviteFilterCategory = RxString("");

  /// List of trip invites
  RxList<TripResponse> filteredInvites = <TripResponse>[].obs;

  /// List of active trips
  RxList<TripResponse> activeTrips = <TripResponse>[].obs;

  /// Current trip category filter index
  RxInt activeTripCategoryFilter = RxInt(0);

  /// Current active filter index
  RxString activeTripFilterCategory = RxString("");

  /// List of active schedules
  RxList<TripResponse> filteredActiveTrips = <TripResponse>[].obs;

  /// List of trip history
  RxList<TripResponse> tripHistory = <TripResponse>[].obs;

  /// Current trip history filter index
  RxString tripHistoryFilterCategory = RxString("");

  /// Selected filter date formatted
  Rx<DateTime> selectedTripHistoryFilterDate = DateTime(2009).obs;

  /// Current trip category category filter index
  RxInt historyTripCategoryFilter = RxInt(0);

  /// Current trip history status filter index
  RxInt historyTripShareFilter = RxInt(0);

  /// Selected filter status
  RxString selectedTripHistoryShareFilter = RxString("");

  /// List of trips
  RxList<TripResponse> filteredTripHistory = <TripResponse>[].obs;

  /// Fetching trips
  RxBool isFetchingTrips = RxBool(true);
}