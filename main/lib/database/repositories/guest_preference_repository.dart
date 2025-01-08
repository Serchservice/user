import 'dart:convert';

import 'package:user/library.dart';

class GuestPreferenceRepository extends RepositoryService<Preference, String> {
  final DatabaseService _service = DatabaseImplementation(guestDatabase);

  @override
  Future<Optional<Preference>> delete(Preference item) async {
    _service.remove("Preference:::${Database.guest.id}");
    return Optional<Preference>.empty();
  }

  @override
  Preference get() {
    String? data = _service.read("Preference:::${Database.guest.id}");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Preference.fromJson(jsonData);
    } else {
      return const Preference();
    }
  }

  @override
  Future<Preference> save(Preference item) async {
    await _service.write("Preference:::${Database.guest.id}", jsonEncode(item.toJson()));
    return item;
  }
}