import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:user/library.dart';

class FolderImplementation implements FolderService {
  @override
  Future<String?> createOrGetFolders() async {
    try {
      final path = await _createOrGetPath();
      if (path != null) {
        final directory = Directory(path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        for (var dir in directories(directory.path)) {
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
        }
        return directory.path;
      }
      throw SerchException("Folder path is null");
    } on Exception catch (e) {
      log(e.toString(), from: "Folder Logic - Get or Create Folder");
      return null;
    }
  }

  Future<String?> _createOrGetPath() async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        /// getExternalStorageDirectory
        directory = await getApplicationDocumentsDirectory();
        String serchPath = "";
        List<String> folders = directory.path.split("/");
        for (int x = 1; x < folders.length; x++) {
          String folder = folders[x];
          if (folder != "Android") {
            serchPath += "/$folder";
          } else {
            break;
          }
        }
        return "$serchPath/${Folders.parent}";
      } else {
        directory = await getApplicationDocumentsDirectory();
        return "${directory.path}/${Folders.parent}";
      }
    } on Exception catch (_) {
      directory = await getApplicationDocumentsDirectory();
      return "${directory.path}/${Folders.parent}";
    }
  }

  List<Directory> directories(String path) => [
    Directory('$path/${Folders.audio}'),
    Directory('$path/${Folders.document}'),
    Directory('$path/${Folders.image}'),
    Directory('$path/${Folders.video}'),
  ];

  @override
  void fetchImageData({required String url, required Function(Uint8List) onSuccess, required Function(String) onError}) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        Uint8List imageData = Uint8List.fromList(response.data);
        onSuccess.call(imageData);
      } else {
        onError.call('Failed to fetch image data');
      }
    } catch (error) {
      onError.call('Error: $error');
    }
  }

  @override
  Future<String?> getFolder(String folderName) async {
    final serchDirectory = await _createOrGetPath();
    if(serchDirectory != null) {
      final folderPath = "$serchDirectory/$folderName";

      final folderDirectory = Directory(folderPath);
      if (!await folderDirectory.exists()) {
        await folderDirectory.create(recursive: true);
      }

      return folderPath;
    } else {
      return null;
    }
  }

  @override
  Future<bool> isInFolder(String fileName, String folderName) async {
    try {
      final folder = await getFolder(folderName);
      if(folder != null) {
        final folderDirectory = Directory(folder);
        if (!folderDirectory.existsSync()) {
          return false;
        } else {
          File file = File("$folder/$fileName");
          return file.existsSync();
        }
      }
      return false;
    } on Exception catch(e) {
      log(e.toString(), from: "Folder Logic - Download file to Folder");
      return false;
    }
  }

  @override
  void download({
    String url = "", Uint8List? data, required String folder, required String fileName,
    required Function(Uint8List) onSuccess, required Function(String) onError
  }) async {
    assert(url.isNotEmpty && data == null);
    try {
      final folderName = await getFolder(folder);
      if(folderName != null) {
        final folderDirectory = Directory(folderName);
        if (!await folderDirectory.exists()) {
          await folderDirectory.create(recursive: true);
        }

        if(data != null) {
          File file = File("$folderName/$fileName");
          await file.writeAsBytes(data, flush: true);
        } else {
          File file = File("$folderName/$fileName");
          fetchImageData(
            url: url,
            onSuccess: (data) async {
              await file.writeAsBytes(data, flush: true);
              onSuccess.call(data);
            },
            onError: onError
          );
        }
      } else {
        onError.call("Folder not found");
      }
    } on Exception catch(e) {
      onError.call("Error: $e");
    }
  }
}