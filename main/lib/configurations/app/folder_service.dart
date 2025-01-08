import 'dart:typed_data';

/// This class will initialize certain materials and resources for the platform.
abstract class FolderService {
  /// Creates or retrieves the necessary folders.
  ///
  /// @return A `Future` that completes with the path of the created or retrieved folders, or `null` if unsuccessful.
  Future<String?> createOrGetFolders();

  /// Fetches image data from the specified URL.
  ///
  /// @param url The URL of the image to fetch.
  /// @param onSuccess The callback function to be called with the image data upon successful fetch.
  /// @param onError The callback function to be called with an error message if the fetch fails.
  void fetchImageData({
    required String url,
    required Function(Uint8List) onSuccess,
    required Function(String) onError
  });

  /// Get the folder path
  ///
  /// @param Folder name [Folders]
  Future<String?> getFolder(String folderName);

  /// Downloads data from the specified URL or uses the provided data and saves it to the specified folder with the given file name.
  ///
  /// @param url The URL to download the data from. Defaults to an empty string.
  /// @param data The data to be downloaded. If not provided, data will be fetched from the URL.
  /// @param folder The folder to save the downloaded data to.
  /// @param fileName The name of the file to save the data as.
  /// @param onSuccess The callback function to be called with the downloaded data upon successful download.
  /// @param onError The callback function to be called with an error message if the download fails.
  void download({
    String url = "",
    Uint8List? data,
    required String folder,
    required String fileName,
    required Function(Uint8List) onSuccess,
    required Function(String) onError
  });

  /// Checks if the specified file is in the given folder.
  ///
  /// @param fileName The name of the file to check.
  /// @param folderName The name of the folder to check in.
  ///
  /// @return A `Future` that completes with a boolean indicating whether the file is in the folder.
  Future<bool> isInFolder(String fileName, String folderName);
}