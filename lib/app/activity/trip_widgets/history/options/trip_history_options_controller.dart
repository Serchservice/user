import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:user/library.dart';

class TripHistoryOptionsController extends GetxController {
  final TripResponse trip;
  TripHistoryOptionsController({required this.trip});

  final state = TripHistoryOptionsState();

  final HomeController _home = HomeController.data;
  final ConnectService _connect = Connect();

  @override
  void onInit() {
    state.trip.value = trip;
    super.onInit();
  }


  List<ButtonView> buttons(BuildContext context) => [
    // ButtonView(
    //   header: "Rate trip",
    //   icon: Icons.star_rate_rounded,
    //   color: CommonColors.yellow,
    //   index: 0
    // ),
    ButtonView(
      header: "View trip details",
      icon: Icons.data_exploration_rounded,
      color: Theme.of(context).primaryColor,
      index: 1,
      path: ""
    ),
  ];

  List<ButtonView> invitedButtons(BuildContext context) => [
    ButtonView(
      header: "Rebook trip with ${state.trip.value.shared!.profile!.name}",
      icon: Icons.read_more_rounded,
      color: Theme.of(context).primaryColor,
      index: 2,
      path: ""
    ),
    ButtonView(
      header: state.trip.value.shared!.profile!.isBookmarked
        ? state.isBookmarkingInvited.value
          ? "Unbookmarking ${state.trip.value.shared!.profile!.name}"
          : "Unbookmark ${state.trip.value.shared!.profile!.name}"
        : state.isBookmarkingInvited.value
          ? "Bookmarking ${state.trip.value.shared!.profile!.name}"
          : "Bookmark ${state.trip.value.shared!.profile!.name}",
      icon: state.trip.value.shared!.profile!.isBookmarked
        ? state.isBookmarkingInvited.value
          ? Icons.bookmark_outline_rounded
          : Icons.bookmark_added_rounded
        : state.isBookmarkingInvited.value
          ? Icons.bookmark_added_outlined
          : Icons.bookmark_add,
      color: CommonColors.yellow,
      index: 3
    ),
    ButtonView(
      header: state.isSharingInvited.value
        ? "Creating request-sharing link for ${state.trip.value.shared!.profile!.name}"
        : "Create request-sharing link for ${state.trip.value.shared!.profile!.name}",
      icon: CupertinoIcons.link,
      color: Theme.of(context).primaryColor,
      index: 4,
      path: ""
    ),
  ];

  List<ButtonView> providerButtons(BuildContext context) => [
    ButtonView(
      header: "Rebook trip with ${state.trip.value.provider!.name}",
      icon: Icons.read_more_rounded,
      color: Theme.of(context).primaryColor,
      index: 5,
      path: ""
    ),
    ButtonView(
      header: state.trip.value.provider!.isBookmarked
        ? state.isBookmarkingProvider.value
          ? "Unbookmarking ${state.trip.value.provider!.name}"
          : "Unbookmark ${state.trip.value.provider!.name}"
        : state.isBookmarkingProvider.value
          ? "Bookmarking ${state.trip.value.provider!.name}"
          : "Bookmark ${state.trip.value.provider!.name}",
        icon: state.trip.value.provider!.isBookmarked
          ? state.isBookmarkingProvider.value
          ? Icons.bookmark_outline_rounded
          : Icons.bookmark_added_rounded
          : state.isBookmarkingProvider.value
          ? Icons.bookmark_added_outlined
          : Icons.bookmark_add,
      color: CommonColors.yellow,
      index: 6
    ),
    ButtonView(
      header: state.isSharingProvider.value
        ? "Creating request-sharing link for ${state.trip.value.provider!.name}"
        : "Create request-sharing link for ${state.trip.value.provider!.name}",
      icon: CupertinoIcons.link,
      color: Theme.of(context).primaryColor,
      index: 7,
      path: ""
    ),
  ];

  List<HistoryOption> historyOptions(BuildContext context) => [
    HistoryOption(header: "Trip Options", options: buttons(context)),
    if(state.trip.value.provider != null) ...[
      HistoryOption(header: "Provider Options", options: providerButtons(context)),
    ],
    if(state.trip.value.shared != null && !state.trip.value.shared!.isOffline) ...[
      HistoryOption(header: "Shared Provider Options", options: invitedButtons(context)),
    ]
  ];

  void act(int index) {
    if(index == 0) {
      Navigate.back();
      RatingSheet.open(
        onSuccess: (s, d) {
          _home.activity.fetchTrips(showLoader: true);
          Navigate.back();
        },
        trip: state.trip.value
      );
    } else if(index == 1) {
      Navigate.back();
      TripHistoryView.open(state.trip.value);
    } else if(index == 2) {
      rebookTripWithInvited();
    } else if(index == 3) {
      bookmarkInvited();
    } else if(index == 4) {
      shareInvited();
    } else if(index == 5) {
      rebookTripWithProvider();
    } else if(index == 6) {
      bookmarkProvider();
    } else {
      shareProvider();
    }
  }

  void rebookTripWithProvider() async {
    Loading.open();
    ApiResponse response = await _connect.get(endpoint: "/trip/rebook?id=${state.trip.value.id}");
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      _home.activity.addToInvite(trip);

      Navigate.till(ModalRoute.withName(HomeLayout.route));
      RequestedTripView.open(trip);
    } else {
      Navigate.back();
      notify.error(message: response.message);
    }
  }

  void rebookTripWithInvited() async {
    Loading.open();
    ApiResponse response = await _connect.get(endpoint: "/trip/rebook?id=${state.trip.value.id}&withInvited=true");
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      _home.activity.addToInvite(trip);

      Navigate.till(ModalRoute.withName(HomeLayout.route));
      RequestedTripView.open(trip);
    } else {
      Navigate.back();
      notify.error(message: response.message);
    }
  }

  void bookmarkInvited() async {
    if(state.isBookmarkingInvited.value) {
      return;
    } else {
      state.isBookmarkingInvited.value = true;

      if(state.trip.value.shared!.profile!.isBookmarked) {
        ApiResponse response = await _connect.delete(endpoint: "/bookmark/remove?id=${state.trip.value.shared!.profile!.bookmark}");

        state.isBookmarkingInvited.value = false;
        if(response.isOk) {
          state.trip.value = state.trip.value.copyWith(
            shared: state.trip.value.shared!.copyWith(profile: state.trip.value.shared!.profile!.copyWith(bookmark: ""))
          );
          notify.success(message: response.message);
        } else {
          notify.error(message: response.message);
        }
      } else {
        ApiResponse response = await _connect.post(endpoint: "/bookmark/add", body: {"user": state.trip.value.shared!.profile!.id});
        state.isBookmarkingInvited.value = false;

        if(response.isOk) {
          state.trip.value = state.trip.value.copyWith(
            shared: state.trip.value.shared!.copyWith(
              profile: state.trip.value.shared!.profile!.copyWith(bookmark: response.data)
            )
          );
          notify.success(message: response.message);
        } else {
          notify.error(message: response.message);
        }
      }
    }
  }

  void bookmarkProvider() async {
    if(state.isBookmarkingProvider.value) {
      return;
    } else {
      state.isBookmarkingProvider.value = true;

      if(state.trip.value.provider!.isBookmarked) {
        ApiResponse response = await _connect.delete(endpoint: "/bookmark/remove?id=${state.trip.value.provider!.bookmark}");

        state.isBookmarkingProvider.value = false;
        if(response.isOk) {
          state.trip.value = state.trip.value.copyWith(provider: state.trip.value.provider!.copyWith(bookmark: ""));
          notify.success(message: response.message);
        } else {
          notify.error(message: response.message);
        }
      } else {
        ApiResponse response = await _connect.post(endpoint: "/bookmark/add", body: {"user": state.trip.value.provider!.id});

        state.isBookmarkingProvider.value = false;
        if(response.isOk) {
          state.trip.value = state.trip.value.copyWith(provider: state.trip.value.provider!.copyWith(bookmark: response.data));
          notify.success(message: response.message);
        } else {
          notify.error(message: response.message);
        }
      }
    }
  }

  void shareInvited() async {
    if(state.isSharingInvited.value) {
      return;
    } else {
      state.isSharingInvited.value = true;
      ApiResponse response = await _connect.get(endpoint: "/guest/shared/create?id=${state.trip.value.id}&withInvited=true");

      state.isSharingInvited.value = false;
      if(response.isOk) {
        notify.success(message: "Link generated. Go to Centre -> Account -> Links to view your links.");
        _home.shared.updateList(response.data);
      } else {
        notify.error(message: response.message);
      }
    }
  }

  void shareProvider() async {
    if(state.isSharingProvider.value) {
      return;
    } else {
      state.isSharingProvider.value = true;
      ApiResponse response = await _connect.get(endpoint: "/guest/shared/create?id=${state.trip.value.id}");

      state.isSharingProvider.value = false;
      if(response.isOk) {
        notify.success(message: "Link generated. Go to Centre -> Account -> Links to view your links.");
        _home.shared.updateList(response.data);
      } else {
        notify.error(message: response.message);
      }
    }
  }
}

class HistoryOption {
  final String header;
  final List<ButtonView> options;

  HistoryOption({required this.header, required this.options});
}