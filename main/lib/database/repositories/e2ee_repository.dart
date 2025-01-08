import 'dart:convert';

import 'package:user/library.dart';

class E2EERepository extends RepositoryService<E2EE, String> {
  final DatabaseService _service = DatabaseImplementation(authDatabase);

  @override
  Future<Optional<E2EE>> delete(E2EE item) async {
    if(get().privateKey.isNotEmpty) {
      _service.remove("enc");
    }
    return Optional<E2EE>.empty();
  }

  @override
  E2EE get() {
    String? data = _service.read("enc");

    if(data != null) {
      return E2EE.fromJson(jsonDecode(data));
    } else {
      return E2EE.empty();
    }
  }

  @override
  Future<E2EE> save(E2EE item) async {
    await _service.write("enc", jsonEncode(item.toJson()));
    return item;
  }
}