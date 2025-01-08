import 'dart:convert';

import 'package:user/library.dart';

class AppSettingRepository extends RepositoryService<AppSetting, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<AppSetting>> delete(AppSetting item) async {
    _service.remove("AppSetting");
    return Optional<AppSetting>.empty();
  }

  @override
  AppSetting get() {
    String? data = _service.read("AppSetting");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return AppSetting.fromJson(jsonData);
    } else {
      return AppSetting.empty();
    }
  }

  @override
  Future<AppSetting> save(AppSetting item) async {
    await _service.write("AppSetting", jsonEncode(item.toJson()));
    return item;
  }
}