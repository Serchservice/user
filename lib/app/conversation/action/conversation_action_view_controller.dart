import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:user/library.dart';

class ConversationActionViewController extends GetxController {
  final String provider;
  final RequestSearch? search;
  ConversationActionViewController({required this.provider, this.search});

  final state = ConversationActionViewState();

  final FolderService _folderService = FolderImplementation();
  final ConnectService _connect = Connect();

  final TextEditingController description = TextEditingController();
  final TextEditingController item = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController quantity = TextEditingController();

  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterSoundRecord _recorder = FlutterSoundRecord();

  final args = Get.arguments;

  @override
  void onReady() {
    quantity.text = "1";

    amount.addListener(() {
      if(amount.text.trim().isNotEmpty) {
        state.amount.value = amount.text.trim();
      }
    });

    description.addListener(() {
      if(description.text.isNotEmpty) {
        state.showRecorder.value = false;
      } else {
        state.showRecorder.value = true;
      }
    });

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
    super.onReady();
  }

  @override
  void onClose() {
    description.dispose();
    item.dispose();
    amount.dispose();
    quantity.dispose();

    _audioPlayer.dispose();
    _recorder.dispose();
    _timer?.cancel();

    super.onClose();
  }

  Future<void> startRecording() async {
    if(await _recorder.isPaused()) {
      await _recorder.resume();
      state.isRecording.value = true;
      state.isPausedRecording.value = false;
      startTimer();
    } else {
      final bool isPermissionGranted = await _recorder.hasPermission();
      if (!isPermissionGranted) {
        notify.info(message: "Unable to start recording. Storage and microphone permission needs to be granted");
        return;
      }

      // Generate a unique file name using the current timestamp
      String fileName = 'STA_${DateTime.now().millisecondsSinceEpoch}.m4a';
      String? folderPath = await _folderService.getFolder(Folders.audio);
      if(folderPath != null) {
        File path = File('$folderPath/$fileName');
        state.media.value = state.media.value.copyWith(path: path.path);

        await _recorder.start(path: path.path);
      } else {
        await _recorder.start();
      }

      state.isRecording.value = true;
      state.showKeyboard.value = false;
      startTimer();
    }
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (newTimer) {
      _timer = newTimer;

      state.recordingTimer.value++;
    });
  }

  String recordingTime() {
    String minutes = CommonUtility.formatAudioTimer(state.recordingTimer.value ~/ 60);
    String seconds = CommonUtility.formatAudioTimer(state.recordingTimer.value % 60);
    return "$minutes : $seconds";
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void deleteRecording() async {
    await _recorder.stop();
    pauseTimer();
    state.isRecording.value = false;
    state.isPausedRecording.value = false;
    state.isStoppedRecording.value = false;
    state.recordingTimer.value = 0;
    state.media.value = SelectedMedia(path: "");
    state.showKeyboard.value = true;
  }

  Future<void> pauseRecording() async {
    await _recorder.pause();
    pauseTimer();
    state.isRecording.value = false;
    state.isPausedRecording.value = true;
  }

  Future<void> stopRecording() async {
    String? result = await _recorder.stop();

    if(result != null) {
      state.media.value = state.media.value.copyWith(path: result);
    }
    pauseTimer();
    prepareMedia();
    state.isStoppedRecording.value = true;
    state.recordingTimer.value = 0;
    state.isRecording.value = false;
    state.isPausedRecording.value = false;
    state.showKeyboard.value = false;

    if(state.media.value.path.isNotEmpty) {
      await _audioPlayer.setAudioSource(AudioSource.file(state.media.value.path));
      state.totalDuration.value = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
    }
  }

  void prepareMedia() async {
    File file = File(state.media.value.path);
    String size = AssetUtility.getFileSize(file: file) ?? "";

    state.media.value = SelectedMedia(
      path: file.path,
      size: size,
      media: MediaType.photo,
      data: await file.readAsBytes(),
      isCamera: false
    );
  }

  ButtonView recordingOptions() {
    if(state.isRecording.isTrue) {
      return ButtonView(
        icon: CupertinoIcons.pause,
        header: "Pause recording",
        onClick: () => pauseRecording(),
        color: CommonColors.error
      );
    } else {
      return ButtonView(
        icon: CupertinoIcons.mic,
        header: "Record",
        onClick: () => startRecording(),
        color: CommonColors.error
      );
    }
  }

  Future<void> playAudio() async {
    if(state.media.value.path.isNotEmpty) {
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

  void deleteAudio() async {
    await _audioPlayer.stop();
    state.currentPosition.value = 0.0;
    state.isPlaying.value = false;
    state.isStoppedRecording.value = false;
    state.media.value = SelectedMedia(path: "");
    state.showKeyboard.value = true;
  }

  void seek(double value) async {
    state.currentPosition.value = value;
    _audioPlayer.seek(Duration(seconds: value.toInt()));
    if(!state.isPlaying.value) {
      _audioPlayer.pause();
    }
  }

  bool get showButton => search != null
    ? state.amount.isNotEmpty
    :  state.location.value.place.isNotEmpty && (state.media.value.path.isNotEmpty || description.text.isNotEmpty)
      && state.amount.isNotEmpty;

  void runSearch() async {
    if(search == null) {
      if(state.location.value.latitude == 0.0) {
        notify.error(message: "Your location is needed to proceed");
        return;
      }

      if(description.text.isEmpty && state.media.value.path.isEmpty) {
        notify.error(message: "You need to either describe the problem or use audio");
        return;
      }
    }

    if(state.amount.value.isEmpty) {
      notify.error(message: "Amount cannot be empty. Please fill in the workmanship amount agreed");
      return;
    }

    Loading.open();
    ApiResponse response = await _connect.post(
      endpoint: "/trip/request",
      body: search != null ? {
        "address": search!.address.place,
        "latitude": search!.address.latitude,
        "longitude": search!.address.longitude,
        "provider": provider,
        "amount": amount.text.trim(),
        "audio": {
          "path": search!.audio?.path,
          "media": search!.audio?.media.type,
          "bytes": search!.audio?.data
        },
        "problem": search!.description,
        "car": search!.car,
        "place_id": search!.address.id,
      } : {
        "address": state.location.value.place,
        "latitude": state.location.value.latitude,
        "longitude": state.location.value.longitude,
        "provider": provider,
        "amount": amount.text.trim(),
        "audio": {
          "path": state.media.value.path,
          "media": state.media.value.media.type,
          "bytes": state.media.value.data
        },
        "problem": description.text.trim(),
        "place_id": state.location.value.id,
      }
    );
    if(response.isSuccessful) {
      TripResponse trip = TripResponse.fromJson(response.data);
      HomeController.data.activity.addToInvite(trip);

      Navigate.till(ModalRoute.withName(HomeLayout.route));
      RequestedTripView.open(trip);
    } else {
      Navigate.back();
      notify.error(message: response.message);
    }
  }
}