import 'dart:convert';

import 'package:user/library.dart';

class GuestRepository extends RepositoryService<Guest, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<Guest>> delete(Guest item) async {
    _service.remove("Guest");
    return Optional<Guest>.empty();
  }

  @override
  Guest get() {
    String? data = _service.read("Guest");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Guest.fromJson(jsonData);
    } else {
      return Guest.empty();
    }
  }

  @override
  Future<Guest> save(Guest item) async {
    await _service.write("Guest", jsonEncode(item.toJson()));
    return item;
  }
}