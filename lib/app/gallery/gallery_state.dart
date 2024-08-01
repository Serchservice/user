import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';

class GalleryState {
  /// All albums
  RxList<Album> albums = <Album>[].obs;

  /// Is video gallery
  RxBool isVideo = RxBool(false);

  /// Is for chat
  RxBool isChat = RxBool(false);

  /// Title
  RxString title = RxString("");

  /// Reciever id for chat
  RxString receiver = RxString("");
}