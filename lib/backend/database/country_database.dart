import 'dart:convert';

import 'package:user/library.dart';

class CountryDatabase extends RepositoryService<List<Country>, String> {
  final DatabaseService _service = DatabaseImplementation(settingsDatabase);

  @override
  Future<Optional<List<Country>>> delete(List<Country> item) async {
    _service.remove("countries");
    return Optional<List<Country>>.empty();
  }

  @override
  List<Country> get() {
    List<dynamic>? data = _service.read("countries");

    if(data != null) {
      return data.map((e) => Country.fromJson(jsonDecode(e))).toList();
    } else {
      return List<Country>.empty();
    }
  }

  @override
  Future<List<Country>> save(List<Country> item) async {
    await _service.write("countries", item.map((e) => jsonEncode(e.toJson())).toList());
    return item;
  }
}