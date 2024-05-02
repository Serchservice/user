import 'dart:convert';

import 'package:user/library.dart';

class AddressDatabase extends RepositoryService<Address, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<Address>> delete(Address item) async {
    _service.remove("address");
    return Optional<Address>.empty();
  }

  @override
  Address get() {
    String? data = _service.read("address");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return Address.fromJson(jsonData);
    } else {
      return const Address();
    }
  }

  @override
  Future<Address> save(Address item) async {
    await _service.write("address", jsonEncode(item.toJson()));
    return item;
  }
}