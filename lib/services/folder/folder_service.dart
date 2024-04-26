import 'dart:io';
import 'dart:typed_data';

/// This class will initialize certain materials and resources for the platform.
abstract class FolderService {
  /// List of folders the app uses
  List<Directory> directories(String path);

  /// Create or get the path if it is already created
  Future<String?> createOrGetPath();

  /// Create or get folders if it is already created
  Future<String?> createOrGetFolders();

  /// Add a file to the folder
  Future<void> addFileToFolder(String fileName, String folderName, Uint8List bytes);

  /// Download a file and save it to a folder
  Future<void> downloadFileToFolder(String fileName, String folderName, String url);

  /// Check if the file is in any folder
  Future<bool> isFileInFolder(String fileName, String folderName);

  /// Get a folder
  Future<String?> getFolder(String folderName);
}