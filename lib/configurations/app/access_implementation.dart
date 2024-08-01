import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/library.dart';

class AccessImplementation implements AccessService {
  /// Storage Permissions
  final List<Permission> storagePermissions = [
    if(Platform.isAndroid) ...[
      if(Database.device.sdk > 32)...[
        Permission.photos,
        Permission.videos
      ],
      if(Database.device.sdk <= 32) ...[
        Permission.storage,
      ],
    ],
    if(Platform.isIOS) ...[
      Permission.photosAddOnly,
      Permission.photos,
      Permission.storage
    ],
  ];

  @override
  Future<bool> hasLocation() async {
    LocationPermission permit = await Geolocator.checkPermission();
    return permit == LocationPermission.always || permit == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermissions() async {
    /// Media Permissions
    final List<Permission> mediaPermissions = [
      Permission.camera,
      Permission.microphone,
    ];

    /// Notification Permissions
    final List<Permission> notificationPermissions = [
      if(Platform.isIOS) ...[
        Permission.criticalAlerts,
      ],
      Permission.notification,
    ];

    var storagePermission = await [...storagePermissions].request();
    var notificationPermission = await [...notificationPermissions].request();
    var mediaPermission = await [...mediaPermissions].request();
    var locationPermission = await Geolocator.requestPermission();

    bool isStorageNotGranted = storagePermission.entries.any((element) => !element.value.isGranted);
    bool isMediaNotGranted = mediaPermission.entries.any((element) => !element.value.isGranted);
    bool isNoticeNotGranted = notificationPermission.entries.any((element) => !element.value.isGranted);
    bool isLocationGranted = locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;

    return !(isStorageNotGranted || isMediaNotGranted || isNoticeNotGranted || !isLocationGranted);
  }

  @override
  Future<bool> hasStorage() async {
    var storagePermission = await [...storagePermissions].request();
    return !storagePermission.entries.any((element) => !element.value.isGranted);
  }
}