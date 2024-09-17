import 'package:user/library.dart';

class GuestHomeActivity implements GuestHomeActivityService {
  final GuestHomeController controller;
  GuestHomeActivity({required this.controller});

  final ConnectService _connect = Connect(useToken: false);

  @override
  void fetchInvites({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingTripInvites.value = true;
    }

    ApiResponse response = await _connect.get(endpoint: "/trip/invite?guest=${Database.guest.id}&link=${Database.preference.active}");
    if(response.isSuccessful) {
      controller.state.isFetchingTripInvites.value = false;
      List<dynamic> list = response.data;
      _buildInviteList(list.map((data) => TripResponse.fromJson(data)).toList());
    }
  }

  void _buildInviteList(List<TripResponse> list) {
    controller.state.invites.value = list;
  }

  @override
  void addToInvite(TripResponse response) {
    List<TripResponse> invites = List.from(controller.state.invites); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = invites.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      invites[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      invites.add(response);
    }

    // Sort the list based on `sentAt`
    invites.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.invites.value = invites;
  }

  @override
  void removeFromInvite(TripResponse response) {
    List<TripResponse> invites = List.from(controller.state.invites); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = invites.indexWhere((i) => i.id == response.id || i.requestedId == response.requestedId);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      invites.remove(invites[existingIndex]);
    }

    // Sort the list based on `sentAt`
    invites.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.invites.value = invites;
  }

  @override
  void fetchTrips({bool showLoader = true}) async {
    if(showLoader) {
      controller.state.isFetchingTrips.value = true;
    }

    ApiResponse response = await _connect.get(endpoint: "/trip/history?guest=${Database.guest.id}&link=${Database.preference.active}");
    if(response.isSuccessful) {
      controller.state.isFetchingTrips.value = false;
      List<dynamic> list = response.data;
      List<TripResponse> trips = list.map((data) => TripResponse.fromJson(data)).toList();

      _buildActiveTripList(trips.where((d) => d.isActive).toList());
      _buildTripHistoryList(trips.where((d) => d.isClosed || d.isUnfulfilled).toList());
    }
  }

  void _buildActiveTripList(List<TripResponse> list) {
    controller.state.actives.value = list;

    for(var trip in list) {
      controller.event.addTripEvent(trip);
    }
  }

  void _buildTripHistoryList(List<TripResponse> list) {
    controller.state.history.value = list;
  }

  @override
  void prepareTrip(data) {
    TripResponse response = TripResponse.fromJson(data);
    if(response.isWaiting) {
      addToInvite(response);
    } else if(response.isActive) {
      addToActiveTrips(response);
      removeFromInvite(response);
    } else {
      addToTripHistory(response);
      removeFromActiveTrips(response);
    }
  }

  @override
  void prepareTrips(List<dynamic> data) {
    List<TripResponse> list = data.map((d) => TripResponse.fromJson(d)).toList();
    if(list.any((d) => d.isWaiting)) {
      _buildInviteList(list.where((d) => d.isWaiting).toList());
    } else if(list.any((d) => d.isActive)) {
      _buildActiveTripList(list.where((d) => d.isActive).toList());
    } else {
      _buildTripHistoryList(list.where((d) => d.isClosed || d.isUnfulfilled).toList());
    }
  }

  @override
  void addToActiveTrips(TripResponse response) {
    List<TripResponse> actives = List.from(controller.state.actives);
    int existingIndex = actives.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      actives[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      actives.add(response);
    }

    // Sort the list based on `sentAt`
    actives.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    controller.state.actives.value = actives;
  }

  @override
  void removeFromActiveTrips(TripResponse response) {
    List<TripResponse> actives = List.from(controller.state.actives); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = actives.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      actives.remove(actives[existingIndex]);
    }

    // Sort the list based on `sentAt`
    actives.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.actives.value = actives;
  }

  @override
  void addToTripHistory(TripResponse response) {
    List<TripResponse> history = List.from(controller.state.history);
    int existingIndex = history.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      history[existingIndex] = response;
    } else {
      // If the response does not exist, add the new response
      history.add(response);
    }

    // Sort the list based on `sentAt`
    history.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    controller.state.history.value = history;
  }

  @override
  void removeFromTripHistory(TripResponse response) {
    List<TripResponse> history = List.from(controller.state.history); // Create a copy to avoid modifying the controller.state directly
    // Find the index of the existing response
    int existingIndex = history.indexWhere((i) => i.id == response.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      history.remove(history[existingIndex]);
    }

    // Sort the list based on `sentAt`
    history.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    // Update the controller.state with the new list
    controller.state.history.value = history;
  }
}