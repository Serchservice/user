import 'dart:typed_data';

/// This class will initialize certain materials and resources for the platform.
abstract class FolderService {
  /// Create or get folders if it is already created
  Future<String?> createOrGetFolders();

  void fetchImageData({
    required String url,
    required Function(Uint8List) onSuccess,
    required Function(String) onError
  });

  void download({
    String url = "",
    Uint8List? data,
    required String folder,
    required String fileName,
    required Function(Uint8List) onSuccess,
    required Function(String) onError
  });

  /// Check if the file is in any folder
  Future<bool> isInFolder(String fileName, String folderName);
}