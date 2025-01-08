import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RequestEntryController extends GetxController {
  RequestEntryController();
  final state = RequestEntryState();

  final FolderService _folderService = FolderImplementation();
  final ConnectService _connect = Connect(useToken: Database.isUserActive);

  final TextEditingController description = TextEditingController();
  final TextEditingController item = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController car = TextEditingController();
  final TextEditingController searchAmount = TextEditingController();

  Timer? _timer;

  final FlutterSoundRecord _recorder = FlutterSoundRecord();

  final args = Get.arguments;
  final _params = Get.parameters;

  @override
  void onInit() {
    state.current.value = _params["c"] ?? "";

    if(args != null) {
      if(args["category"] != null) {
        state.initial.value = SerchCategory.fromJson(args["category"]);
      }

      if(args["provider"] != null) {
        state.provider.value = SharedUser.fromJson(args["provider"]);
      }

      if(args["search"] != null) {
        state.search.value = RequestSearch.fromJson(args["search"]);
      }
    }

    updateCategoryList();

    super.onInit();
  }

  bool get isDrive => state.current.value == "drive";
  bool get isSpeak => state.current.value == "speak";
  bool get isRequest => !(isDrive || isSpeak) || hasProvider;

  void updateCategoryList() {
    if(isDrive && HomeController.data.state.isFetchingCategories.isFalse) {
      state.categories.value = HomeController.data.state.categories
          .where((category) => category.canDrive)
          .toList();
    } else {
      state.categories.value = HomeController.data.state.categories;
    }
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

    searchAmount.addListener(() {
      if(searchAmount.text.trim().isNotEmpty) {
        state.searchAmount.value = searchAmount.text.trim();
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
    car.dispose();
    searchAmount.dispose();

    _recorder.dispose();
    _timer?.cancel();

    super.onClose();
  }

  String get title => isSpeak
      ? "Who do you want to speak with?"
      : isDrive
      ? "Where do you want to drive to?"
      : hasProvider
      ? "Invite ${state.provider.value.name}"
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

    if(state.isRecording.isFalse) {
      notify.tip(
        message: "Trying to record but no response? Use the text option. Recording might not be supported for your device.",
        color: CommonColors.allday,
        duration: 30
      );
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

  SerchCategory get selectedCategory => state.initial.value.category.isNotEmpty
      ? state.initial.value
      : state.selected.value;

  bool get hasProvider => state.provider.value.id.isNotEmpty;

  bool get hasContent => hasProvider && Database.isUserActive
    ? state.searchAmount.value.isNotEmpty
    : (state.media.value.path.isNotEmpty || description.text.isNotEmpty);

  bool get hasLocation => state.location.value.hasAddress || state.search.value.address.hasAddress;

  bool get hasCategory => selectedCategory.category.isNotEmpty || hasProvider;

  bool get showButton => isRequest
      ? hasCategory && hasLocation && hasContent
      : hasCategory && hasLocation;

  void search() async {
    if(!hasLocation) {
      notify.error(message: "Your location is needed to proceed");
      return;
    }

    if(!hasCategory) {
      notify.error(message: "You must select service category in order to continue");
      return;
    }

    if(isRequest && !hasProvider && Database.isUserActive) {
      if(car.text.isEmpty && (selectedCategory.isMechanic || state.provider.value.isMechanic)) {
        notify.error(message: "You need to tell us the car model");
        return;
      }

      if((selectedCategory.isPersonalShopper || state.provider.value.isPersonalShopper) && state.items.isEmpty) {
        notify.error(message: "You need to add some items to your cart");
        return;
      }

      if(description.text.isEmpty && state.media.value.path.isEmpty && !(selectedCategory.isPersonalShopper || state.provider.value.isPersonalShopper)) {
        notify.error(message: "You need to either describe the problem or use audio");
        return;
      }
    }

    if(hasProvider && state.searchAmount.value.isEmpty && Database.isUserActive) {
      notify.error(message: "Amount cannot be empty. Please fill in the workmanship amount you've agreed on.");
      return;
    }

    RequestSearch search = RequestSearch(
      address: state.location.value,
      shoppingItems: state.items,
      description: description.text,
      audio: state.media.value,
      car: car.text,
      isDrive: isDrive,
      category: selectedCategory,
    );

    if(isRequest) {
      Loading.open();

      String endpoint = "/trip/invite/request";
      String url = Database.isUserActive
          ? endpoint
          : "$endpoint/${Database.guest.id}/${Database.preference.active}";

      Address location = state.location.value.hasAddress
          ? state.location.value
          : state.search.value.address;
      SelectedMedia media = state.search.value.audio != null
          ? state.search.value.audio!
          : state.media.value;
      String problem = state.search.value.description.isNotEmpty
          ? state.search.value.description
          : description.text.trim();
      String carInfo = state.search.value.car.isNotEmpty
          ? state.search.value.car
          : car.text.trim();

      Map<String, dynamic> data = {
        "address": location.place,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "audio": {
          "path": media.path,
          "media": media.media.type,
          "bytes": media.data
        },
        "problem": problem,
        "car": carInfo,
        "place_id": location.id,
      };

      if(hasProvider && Database.isUserActive) {
        data.putIfAbsent("provider", () => state.provider.value.id);
        data.putIfAbsent("amount", () => searchAmount.text.trim());
        data.putIfAbsent("category", () => state.provider.value.category.replaceAll(" ", "_").toUpperCase());
      } else if(Database.isUserActive) {
        data.putIfAbsent("category", () => selectedCategory.category);
      }

      var response = await _connect.post(endpoint: url, body: data);

      if(response.isSuccessful) {
        TripResponse trip = TripResponse.fromJson(response.data);
        ActivityRequestedController.data.addTrip(trip);

        Navigate.till(ModalRoute.withName(Database.isUserActive ? ParentLayout.route : GuestParentLayout.route));
        ActivityRequestedTripView.open(trip);
      } else {
        Navigate.back();
        notify.error(message: response.message);
      }
    } else {
      SearchResultLayout.off(search);
    }
  }
}