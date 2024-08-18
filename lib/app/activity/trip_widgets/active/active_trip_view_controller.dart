import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:user/library.dart';

class ActiveTripViewController extends GetxController {
  final TripResponse trip;
  ActiveTripViewController({required this.trip});

  final state = ActiveTripViewState();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final HomeController _homeController = HomeController.data;
  final SocketService _socket = Socket();
  final ConnectService _connect = Connect();

  final TextEditingController authController = TextEditingController();
  final FocusNode authFocusNode = FocusNode();

  @override
  void onInit() {
    loadAudio();
    state.trip.value = trip;
    super.onInit();
  }

  @override
  void onReady() {
    _audioPlayer.positionStream.listen((position) {
      state.currentPosition.value = position.inSeconds.toDouble();
    });

    _audioPlayer.playerStateStream.listen((value) {
      if(value.processingState == ProcessingState.completed) {
        state.isPlaying.value = false;
      } else if(value.processingState == ProcessingState.ready && value.playing) {
        state.isPlaying.value = true;
      }
    });

    _socket.initialize(
      callback: (frame) {
        if(frame.body != null) {
          updateTrip(TripResponse.fromJson(jsonDecode(frame.body!)));
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${trip.id}/${Database.auth.id}"
    );

    super.onReady();
  }

  void updateTrip(TripResponse trip) {
    state.trip.value = trip;
    state.isSharedOnTheWay.value = trip.shared != null
      && trip.shared!.timelines.any((t) => t.isOnTheWay && !t.isOver);
    state.isProviderOnTheWay.value = trip.timelines.any((t) => t.isOnTheWay && t.isOver);

    if(trip.isClosed) {
      Navigate.back();
      closeActiveTrip();
    } else {
      _homeController.activity.addToActiveTrips(trip);
    }
  }

  void closeActiveTrip() {
    RatingSheet.open(onSuccess: (string, rating) => Navigate.back(), trip: state.trip.value);
    _homeController.event.removeTripEventById(state.trip.value.id);
    _homeController.activity.removeFromActiveTrips(trip);
    Get.delete<ActiveTripViewController>();
  }

  void loadAudio() async {
    if(trip.audio.isNotEmpty) {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(trip.audio)));
      state.totalDuration.value = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _socket.disconnect();
    authController.dispose();
    authFocusNode.dispose();

    super.onClose();
  }

  Future<void> playAudio() async {
    if(trip.audio.isNotEmpty) {
      if(state.currentPosition.value == state.totalDuration.value) {
        seek(0.0);
      }
      _audioPlayer.play();
      state.isPlaying.value = true;
    } else {
      notify.error(message: "Unable to play audio. Audio file not found");
    }
  }

  String playingTime() {
    int totalSeconds = state.currentPosition.value.toInt();
    String minutes = CommonUtility.formatAudioTimer(totalSeconds ~/ 60);
    String seconds = CommonUtility.formatAudioTimer(totalSeconds % 60);
    return "$minutes : $seconds";
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    state.isPlaying.value = false;
  }

  void seek(double value) async {
    state.currentPosition.value = value;
    _audioPlayer.seek(Duration(seconds: value.toInt()));
    if(!state.isPlaying.value) {
      _audioPlayer.pause();
    }
  }

  void cancel(List<TripResponse> trips, bool goBack) {
    if(trips.isNotEmpty) {
      for (var trip in trips) {
        _homeController.activity.addToTripHistory(trip);
      }
      _homeController.activity.removeFromActiveTrips(trip);
    }

    if(goBack) {
      Navigate.back();
    }
  }

  void verifyAuth(String code) async {
    state.authToken.value = code;
    state.isVerifying.value = true;

    var response = await _connect.patch(
      endpoint: "/trip/auth",
      body: {"code": state.authToken.value, "trip": trip.id}
    );

    state.isVerifying.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      _homeController.activity.addToActiveTrips(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void grantAccess() async {
    state.isGrantingAccess.value = true;

    ApiResponse response = await _connect.patch(endpoint: "/trip/shared/access?id=${trip.id}");

    state.isGrantingAccess.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      _homeController.activity.addToActiveTrips(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void denyAccess() async {
    state.isDenyingAccess.value = true;

    ApiResponse response = await _connect.patch(endpoint: "/trip/shared/access?id=${trip.id}");

    state.isDenyingAccess.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      _homeController.activity.addToActiveTrips(trip);
    } else {
      notify.error(message: response.message);
    }
  }

  void end() async {
    state.isEnding.value = true;

    ApiResponse response = await _connect.patch(endpoint: "/trip/end", body: {"trip": trip.id});

    state.isEnding.value = false;
    if(response.isSuccessful) {
      List<dynamic> data = response.data;
      List<TripResponse> trips = data.map((t) => TripResponse.fromJson(t)).toList();
      cancel(trips, true);

      closeActiveTrip();
    } else {
      notify.error(message: response.message);
    }
  }

  void verifySharedAuth(String code) async {
    state.authToken.value = code;
    state.isVerifying.value = true;

    var response = await _connect.patch(
        endpoint: "/trip/shared/auth",
        body: {"code": state.authToken.value, "trip": trip.id}
    );

    state.isVerifying.value = false;
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      state.trip.value = trip;
      _homeController.activity.addToActiveTrips(trip);
    } else {
      notify.error(message: response.message);
    }
  }
}