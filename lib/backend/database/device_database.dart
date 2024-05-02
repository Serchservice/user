import 'dart:convert';

import 'package:user/library.dart';

class DeviceDatabase extends RepositoryService<Device, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<Device>> delete(Device item) async {
    _service.remove("device");
    return Optional<Device>.empty();
  }

  @override
  Device get() {
    String? data = _service.read("device");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Device.fromJson(jsonData);
    } else {
      return Device.empty();
    }
  }

  @override
  Future<Device> save(Device item) async {
    await _service.write("device", jsonEncode(item.toJson()));
    return item;
  }
}