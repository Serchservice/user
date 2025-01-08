import 'dart:convert';
import 'package:universal_io/io.dart';
import 'dart:typed_data';

import 'package:user/library.dart';

class SelectedMedia{
  final String path;
  final String size;
  final String duration;
  final Uint8List? data;
  final String? callbackUrl;
  final MediaType media;
  final bool isCamera;

  SelectedMedia({
    required this.path,
    this.duration = "00:00",
    this.size = "",
    this.data,
    this.callbackUrl,
    this.isCamera = false,
    this.media = MediaType.photo
  });

  SelectedMedia copyWith({
    String? path,
    String? duration,
    String? size,
    Uint8List? data,
    String? callbackUrl,
    MediaType? media,
    bool? isCamera,
  }) {
    return SelectedMedia(
      path: path ?? this.path,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      data: data ?? this.data,
      media: media ?? this.media,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      isCamera: isCamera ?? this.isCamera
    );
  }

  Map<String, dynamic> toJson() => {
    "path": path,
    "duration": duration,
    "size": size,
    "data": data,
    "callback_url": callbackUrl,
    "media": media.type,
    "is_camera": isCamera
  };

  String toJsonString(SelectedMedia media) {
    return jsonEncode(media.toJson());
  }

  factory SelectedMedia.fromJson(dynamic data) {
    if(data is String) {
      Map<String, dynamic> json = jsonDecode(data);

      return SelectedMedia(
        path: json["path"] ?? "",
        duration: json["duration"] ?? "",
        size: json["size"] ?? "",
        data: json["data"],
        callbackUrl: json["callback_url"],
        isCamera: json["is_camera"] ?? false,
        media: (json["media"] as String).toMediaType()
      );
    } else {
      return SelectedMedia(
        path: data["path"] ?? "",
        duration: data["duration"] ?? "",
        size: data["size"] ?? "",
        data: data["data"],
        callbackUrl: data["callback_url"],
        isCamera: data["is_camera"] ?? false,
        media: (data["media"] as String).toMediaType()
      );
    }
  }

  bool get hasContent => path.isNotEmpty || data != null;

  static String toDuration(Duration duration) {
    String formattedDuration = duration.toString().split('.').first;
    // Format as "00:00" (minutes and seconds)
    if (formattedDuration.contains(':')) {
      List<String> parts = formattedDuration.split(':');
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      formattedDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    // Format as "00:00:00" (hours, minutes, and seconds)
    if (formattedDuration.contains(':') && formattedDuration.split(':').length == 3) {
      List<String> parts = formattedDuration.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = int.parse(parts[2]);
      formattedDuration = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return formattedDuration;
  }

  Future<String> getBase64() async {
    Uint8List fileBytes = await File(path).readAsBytes();
    return base64Encode(fileBytes);
  }

  Future<String> getBase64WithPrefix() async {
    String base64String = await getBase64();
    String mimeType = _getMimeType(path);

    return 'data:$mimeType;base64,$base64String';
  }

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      case 'mkv':
        return 'video/x-matroska';
    // Add more cases as needed
      default:
        return 'application/octet-stream';
    }
  }
}