import 'dart:convert';
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

  factory SelectedMedia.fromJson(String data) {
    Map<String, dynamic> json = jsonDecode(data);

    return SelectedMedia(
      path: json["path"],
      duration: json["duration"],
      size: json["size"],
      data: json["data"],
      callbackUrl: json["callback_url"],
      isCamera: json["is_camera"],
      media: (json["media"] as String).toMediaType()
    );
  }

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
}