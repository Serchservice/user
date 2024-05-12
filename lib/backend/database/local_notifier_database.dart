import 'dart:convert';

import 'package:user/library.dart';

class LocalNotifierDatabase extends RepositoryService<LocalNotifier, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<LocalNotifier>> delete(LocalNotifier item) async {
    _service.remove("LocalNotifier");
    return Optional<LocalNotifier>.empty();
  }

  @override
  LocalNotifier get() {
    String? data = _service.read("LocalNotifier");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return LocalNotifier.fromJson(jsonData);
    } else {
      return LocalNotifier();
    }
  }

  @override
  Future<LocalNotifier> save(LocalNotifier item) async {
    await _service.write("LocalNotifier", jsonEncode(item.toJson()));
    return item;
  }
}