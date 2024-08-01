import 'dart:io';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:user/library.dart';

class GalleryController extends GetxController {
  GalleryController();
  final state = GalleryState();
  final params = Get.parameters;
  final AccessService _accessService = AccessImplementation();

  @override
  void onInit() {
    state.isVideo.value = bool.tryParse(params["isVideo"] ?? "") ?? false;
    state.isChat.value = bool.tryParse(params["isChat"] ?? "") ?? false;
    state.title.value = params["title"] ?? "";
    state.receiver.value = params["receiver"] ?? "";

    initializeGallery();
    super.onInit();
  }

  @override
  void onReady() {
    initializeGallery();
    super.onReady();
  }

  void initializeGallery() async {
    Logger.log(await _accessService.hasStorage());
    if(await _accessService.hasStorage()) {
      if(state.isVideo.value) {
        state.albums.value = await PhotoGallery.listAlbums(mediumType: MediumType.video);
      } else {
        state.albums.value = await PhotoGallery.listAlbums(mediumType: MediumType.image);
      }
    }
  }

  void pickFromFile({Function(String)? onError}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: state.isVideo.value ? FileType.video : FileType.image,
        allowMultiple: false,
        dialogTitle: state.title.value
      );

      if(result != null) {
        if(result.files.first.path != null) {
          String path = result.files.first.path ?? result.files.first.name;
          final media = SelectedMedia(
            path: path,
            data: await File(path).readAsBytes(),
            size: AssetUtility.getFileSize(platformFile: result.files.first) ?? "",
          );
          if(state.isChat.value) {
            // Navigate.off(ViewAndSendLayout.route, arguments: {
            //   "data": media.toJsonString(media),
            //   "send_to": state.title.value,
            //   "send_to_id": receiverId
            // });
          } else {
            Navigate.back(result: media);
          }
        }
      } else {
        onError?.call("Unsupported file format");
        return;
      }
    } catch (e) {
      onError?.call("Unsupported file format");
      return;
    }
  }
}