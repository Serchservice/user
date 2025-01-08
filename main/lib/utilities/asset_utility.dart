import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:user/library.dart';

class AssetUtility {
  static ImageProvider image(String image, {String? fallback}) {
    if(image.startsWith('http')) {
      return CachedNetworkImageProvider(
        image,
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorListener: (obj) => AssetImage(fallback ?? Media.logo),
      );
    } else if(image.startsWith('/')) {
      return FileImage(File(image));
    } else if(image.startsWith('data:image')) {
      return MemoryImage(base64Decode(image.split(",").last));
    } else if(image.isNotEmpty) {
      return AssetImage(image);
    } else {
      return AssetImage(
        Database.preference.isDarkTheme
          ? Media.light
          : Media.dark
      );
    }
  }

  static String? getFileSize({File? file, XFile? xFile, PlatformFile? platformFile}) {
    if(file != null) {
      /// Size in KB
      final kb = ((file).lengthSync()/1024).toStringAsFixed(2);
      /// Size in MB
      final mb = ((file).lengthSync()/1024/1024).toStringAsFixed(2);
      final size = double.parse(mb) < 1.00 ? "${kb}kb" : "${mb}mb";
      return size;
    } else if(platformFile != null) {
      final mb = (platformFile).size/1024/1024;
      final kb = (platformFile).size/1024;
      final size = mb < 1.00 ? "$kb KB" : "$mb MB";
      return size;
    } else {
      return null;
    }
  }
}