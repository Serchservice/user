import 'dart:convert';

import 'package:user/library.dart';

class AccountRepository extends RepositoryService<List<Account>, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<List<Account>>> delete(List<Account> item) async {
    _service.remove("Account");
    return Optional<List<Account>>.empty();
  }

  @override
  List<Account> get() {
    List<dynamic>? data = _service.read("Account");

    if(data != null) {
      return data.map((e) => Account.fromJson(jsonDecode(e))).toList();
    } else {
      return List<Account>.empty();
    }
  }

  @override
  Future<List<Account>> save(List<Account> item) async {
    await _service.write("Account", item.map((e) => jsonEncode(e.toJson())).toList());
    return item;
  }
}