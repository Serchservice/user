import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:user/library.dart';

class FolderImplementation implements FolderService {
  @override
  Future<void> addFileToFolder(String fileName, String folderName, Uint8List bytes) async {
    try {
      final folder = await getFolder(folderName);
      if(folder != null) {
        final folderDirectory = Directory(folder);
        if (!await folderDirectory.exists()) {
          await folderDirectory.create(recursive: true);
        }
        File file = File("$folder/$fileName");
        await file.writeAsBytes(bytes, flush: true);
      } else {
        throw SerchException("Folder is null");
      }
    } on Exception catch(e) {
      Logger.log(e.toString(), from: "Folder Logic - Add File To Folder");
    }
  }

  @override
  Future<String?> createOrGetFolders() async {
    try {
      final path = await createOrGetPath();
      if(path != null) {
        final directory = Directory(path);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        directories(directory.path).forEach((directory) async {
          if(!await directory.exists()) {
            await directory.create(recursive: true);
          }
        });
        return directory.path;
      }
      throw SerchException("Folder is null");
    } on Exception catch(e) {
      Logger.log(e.toString(), from: "Folder Logic - Get or Create Folder");
      return null;
    }
  }

  @override
  Future<String?> createOrGetPath() async {
    Directory? directory;
    try {
      if(Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        String serchPath = "";
        List<String> folders = directory!.path.split("/");
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
    } on Exception catch(_) {
      directory = await getApplicationDocumentsDirectory();
      return "${directory.path}/${Folders.parent}";
    }
  }

  @override
  List<Directory> directories(String path) => [
    Directory('$path/${Folders.audio}'),
    Directory('$path/${Folders.document}'),
    Directory('$path/${Folders.image}'),
    Directory('$path/${Folders.video}'),
  ];

  @override
  Future<void> downloadFileToFolder(String fileName, String folderName, String url) async {
    try {
      final folder = await getFolder(folderName);
      if(folder != null) {
        final folderDirectory = Directory(folder);
        if (!await folderDirectory.exists()) {
          await folderDirectory.create(recursive: true);
        }
        File file = File("$folder/$fileName");
      } else {
        throw SerchException("Folder is null");
      }
    } on Exception catch(e) {
      Logger.log(e.toString(), from: "Folder Logic - Download file to Folder");
    }
  }

  @override
  Future<String?> getFolder(String folderName) async {
    final serchDirectory = await createOrGetPath();
    final folderPath = "$serchDirectory/$folderName";
    return folderPath;
  }

  @override
  Future<bool> isFileInFolder(String fileName, String folderName) async {
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
      Logger.log(e.toString(), from: "Folder Logic - Download file to Folder");
      return false;
    }
  }
}