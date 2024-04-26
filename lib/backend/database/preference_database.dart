import 'dart:convert';

import 'package:user/library.dart';

String settingsDatabase = "SETTINGS_DATABASE";

class PreferenceDatabase extends RepositoryService<Preference, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<Preference>> delete(Preference item) async {
    _service.remove("preference");
    return Optional<Preference>.empty();
  }

  @override
  Preference get() {
    String? data = _service.read("preference");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Preference.fromJson(jsonData);
    } else {
      return const Preference();
    }
  }

  @override
  Future<Preference> save(Preference item) async {
    await _service.write("preference", jsonEncode(item.toJson()));
    return item;
  }
}