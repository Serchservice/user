
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class PermissionSheetController extends GetxController {
  final int sdk;

  PermissionSheetController({required this.sdk});
  final state = PermissionSheetState();

  final AccessService _accessService = AccessImplementation();
  final FolderService _folderService = FolderImplementation();

  void grant() {
    state.canPop.value = false;

    requestAccess(sdk, onSuccess: () async {
      try {
        MainConfiguration.data.cameras.value = await availableCameras();
      } catch (_) {}

      await _folderService.createOrGetFolders();

      Database.savePreference(Database.preference.copyWith(hasGrantedPermissions: true));
      state.canPop.value = true;
      Navigate.back();
    });
  }

  Future<void> requestAccess(int sdk, {Function()? onSuccess}) async {
    bool hasAccess = await _accessService.requestPermissions(sdk);
    if(hasAccess) {
      if(PlatformEngine.instance.isMobile || PlatformEngine.instance.isWeb) {
        onSuccess?.call();
        return;
      } else {
        throw SerchException("Unsupported platform", isPlatformNotSupported: true);
      }
    } else {
      requestAccess(sdk, onSuccess: onSuccess);
    }
  }

}