import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/library.dart';

class AccessImplementation implements AccessService {
  /// Storage Permissions
  List<Permission> storagePermissions(int sdk) => [
    if(PlatformEngine.instance.isAndroid) ...[
      if(sdk <= 32) ...[
        Permission.storage,
      ] else ...[
        Permission.photos,
        // Permission.manageExternalStorage
      ]
    ] else if(PlatformEngine.instance.isIOS) ...[
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
  Future<bool> requestPermissions(int sdk) async {
    /// Notification Permissions
    final List<Permission> notificationPermissions = [
      if(PlatformEngine.instance.isIOS) ...[
        Permission.criticalAlerts,
      ],
      Permission.notification,
    ];

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      throw SerchException("Location service is not enabled on this device", isPlatformNotSupported: true);
    }

    var locationPermission = await Geolocator.requestPermission();
    var notificationPermission = await [...notificationPermissions].request();

    bool isNoticeNotGranted = notificationPermission.entries.any((element) => !element.value.isGranted);
    bool isLocationGranted = locationPermission == LocationPermission.always || locationPermission == LocationPermission.whileInUse;

    if(PlatformEngine.instance.isMobile) {
      /// Media Permissions
      final List<Permission> mediaPermissions = [Permission.camera, Permission.microphone];

      var mediaPermission = await [...mediaPermissions].request();
      var storagePermission = await [...storagePermissions(sdk)].request();

      bool isStorageNotGranted = storagePermission.entries.any((element) => !element.value.isGranted);
      bool isMediaNotGranted = mediaPermission.entries.any((element) => !element.value.isGranted);

      return !(isStorageNotGranted || isMediaNotGranted || isNoticeNotGranted || !isLocationGranted);
    } else {
      return !(isNoticeNotGranted || !isLocationGranted);
    }
  }

  @override
  Future<bool> hasStorage() async {
    var storagePermission = await [...storagePermissions(Database.device.sdk)].request();
    return !storagePermission.entries.any((element) => !element.value.isGranted);
  }
}