import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:user/library.dart';

class RequestActionController extends GetxController {
  RequestActionController();

  final state = RequestActionState();
  final HomeController home = HomeController.data;

  final FolderService _folderService = FolderImplementation();
  final ConnectService _connect = Connect();

  final TextEditingController description = TextEditingController();
  final TextEditingController item = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController car = TextEditingController();

  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterSoundRecord _recorder = FlutterSoundRecord();

  final args = Get.arguments;

  @override
  void onInit() {
    if(args != null && args is Map<String, dynamic>) {
      if(args["request"] != null) {
        state.category.value = SerchCategory.fromJson(args["request"]);
      }

      if(args["category"] != null) {
        state.initial.value = SerchCategory.fromJson(args["category"]);
      }
    }

    updateCategoryList();

    super.onInit();
  }

  @override
  void onReady() {
    quantity.text = "1";

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

  void updateCategoryList() {
    if(state.category.value.isDrive && home.state.isFetchingCategories.isFalse) {
      state.categories.value = home.state.categories
          .where((category) => category.canDrive)
          .toList();
    } else {
      state.categories.value = home.state.categories;
    }
  }

  @override
  void onClose() {
    description.dispose();
    item.dispose();
    amount.dispose();
    quantity.dispose();
    car.dispose();

    _audioPlayer.dispose();
    _recorder.dispose();
    _timer?.cancel();

    super.onClose();
  }

  String get title => state.category.value.isSpeak
    ? "Who do you want to speak with?"
    : state.category.value.isDrive
      ? "Where do you want to drive to?"
      : "What service are you looking for?";

  void selectCategory(SerchCategory category) {
    state.selected.value = category;
  }

  void addItem() {
    if(item.text.isEmpty) {
      return;
    } else {
      ShoppingItem shoppingItem = ShoppingItem(
        item: item.text.trim(),
        amount: int.tryParse(amount.text.trim()) ?? 0,
        address: state.shopAddress.value,
        quantity: int.tryParse(quantity.text) ?? 1
      );
      state.items.add(shoppingItem);
      state.totalAmount.value += shoppingItem.amount;
      state.shopAddress.value = Address.empty();
      amount.text = "";
      item.text = "";
      quantity.text = "1";
    }
  }

  void removeItem(ShoppingItem value) {
    state.items.removeWhere((item) => item == value);
    state.totalAmount.value -= value.amount;
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

  bool get showButton => state.category.value.isRequest
    ? state.selected.value.category.isNotEmpty
      && state.location.value.place.isNotEmpty
      && (state.media.value.path.isNotEmpty || description.text.isNotEmpty)
    : state.selected.value.category.isNotEmpty
      && state.location.value.place.isNotEmpty;

  void search() async {
    if(state.location.value.latitude == 0.0) {
      notify.error(message: "Your location is needed to proceed");
      return;
    }

    if(state.selected.value.category.isEmpty) {
      notify.error(message: "You must select service category in order to continue");
      return;
    }

    if(state.category.value.isRequest) {
      if(car.text.isEmpty && state.selected.value.isMechanic) {
        notify.error(message: "You need to tell us the car model");
        return;
      }

      if(state.selected.value.isPersonalShopper && state.items.isEmpty) {
        notify.error(message: "You need to add some items to your cart");
        return;
      }

      if(description.text.isEmpty && state.media.value.path.isEmpty && !state.selected.value.isPersonalShopper) {
        notify.error(message: "You need to either describe the problem or use audio");
        return;
      }
    }

    RequestSearch search = RequestSearch(
      address: state.location.value,
      shoppingItems: state.items,
      description: description.text,
      audio: state.media.value,
      car: car.text,
      category: state.selected.value,
      request: state.category.value
    );

    Map<String, String> data = {
      "mode": state.category.value.category.toLowerCase(),
      "longitude": "${state.location.value.longitude}",
      "latitude": "${state.location.value.latitude}"
    };

    if(state.category.value.isRequest) {
      Loading.open();
      ApiResponse response = await _connect.post(
        endpoint: "/trip/invite/request",
        body: {
          "address": state.location.value.place,
          "latitude": state.location.value.latitude,
          "longitude": state.location.value.longitude,
          // "provider": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          // "guest": "string",
          "category": state.initial.value.category.isNotEmpty
            ? state.initial.value.category
            : state.selected.value.category,
          "audio": {
            "path": state.media.value.path,
            "media": state.media.value.media.type,
            "bytes": state.media.value.data
          },
          "problem": description.text.trim(),
          "car": car.text.trim(),
          // "amount": 0,
          "place_id": state.location.value.id,
        }
      );
      if(response.isSuccessful) {
        TripResponse trip = TripResponse.fromJson(response.data);
        home.activity.addToInvite(trip);

        Navigate.till(ModalRoute.withName(HomeLayout.route));
        RequestedTripView.open(trip);
      } else {
        Navigate.back();
        notify.error(message: response.message);
      }
    } else {
      Navigate.to(ActiveResultLayout.route, parameters: data, arguments: search.toJson());
    }
  }
}