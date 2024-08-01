import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:user/library.dart';

class GuestRequestedTripViewController extends GetxController {
  final TripResponse trip;
  GuestRequestedTripViewController({required this.trip});

  final state = GuestRequestedTripViewState();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final GuestHomeController _homeController = GuestHomeController.data;
  final SocketService _socket = Socket();

  @override
  void onInit() {
    loadAudio();
    state.trip.value = trip;
    super.onInit();
  }

  void loadAudio() async {
    if(trip.audio.isNotEmpty) {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(trip.audio)));
      state.totalDuration.value = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
    }
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
          TripResponse room = TripResponse.fromJson(jsonDecode(frame.body!));
          state.trip.value = room;

          if(room.isActive) {
            closeInvitedAndOpenActive(room);
          } else {
            _homeController.activity.addToInvite(room);
          }
        }
      },
      endpoint: "/ws:serch",
      subscribeDestination: "/platform/${trip.id}/${Database.guest.id}"
    );

    super.onReady();
  }

  void closeInvitedAndOpenActive(TripResponse data) {
    _homeController.activity.removeFromInvite(trip);
    Navigate.back();

    _homeController.activity.addToActiveTrips(data);
    GuestActiveTripView.open(data);
    _homeController.event.addTripEvent(data);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    _socket.disconnect();

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

  void cancelTrip(List<TripResponse> trips, bool goBack) async {
    if(trips.isNotEmpty) {
      for (var trip in trips) {
        _homeController.activity.addToTripHistory(trip);
      }
    }
    _homeController.activity.removeFromInvite(trip);

    if(goBack) {
      Navigate.back();
    }
  }

  void removeQuotation(QuotationResponse quotation) {
    List<QuotationResponse> quotations = List.from(trip.quotations);
    // Find the index of the existing response
    int existingIndex = quotations.indexWhere((i) => i.id == quotation.id);

    if (existingIndex != -1) {
      // If the response exists, update the existing response
      quotations.remove(quotations[existingIndex]);
    }

    // Update the trip with the new list
    trip.copyWith(quotations: quotations);
    state.trip.value = trip;
    _homeController.activity.addToInvite(trip);
  }

  void removeTrip(TripResponse response) {
    closeInvitedAndOpenActive(response);
  }

  void updateTrip(TripResponse response) {
    _homeController.activity.addToInvite(response);
    state.trip.value = response;
  }
}