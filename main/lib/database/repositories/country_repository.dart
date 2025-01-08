import 'dart:convert';

import 'package:user/library.dart';

class CountryRepository extends RepositoryService<List<Country>, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<List<Country>>> delete(List<Country> item) async {
    _service.remove("Country");
    return Optional<List<Country>>.empty();
  }

  @override
  List<Country> get() {
    List<dynamic>? data = _service.read("Country");

    if(data != null) {
      return data.map((e) => Country.fromJson(jsonDecode(e))).toList();
    } else {
      return List<Country>.empty();
    }
  }

  @override
  Future<List<Country>> save(List<Country> item) async {
    await _service.write("Country", item.map((e) => jsonEncode(e.toJson())).toList());
    return item;
  }
}