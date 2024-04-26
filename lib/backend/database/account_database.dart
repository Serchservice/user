import 'dart:convert';

import 'package:user/library.dart';

String accountDatabase = "ACCOUNT_DATABASE";

class AccountDatabase extends RepositoryService<AuthResponse, Session> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<AuthResponse>> delete(AuthResponse item) async {
    if(get().firstName != "") {
      _service.remove("preference");
    }
    return Optional<AuthResponse>.empty();
  }

  @override
  AuthResponse get() {
    return AuthResponse.fromJson(jsonDecode(_service.read("preference")));
  }

  @override
  Future<AuthResponse> save(AuthResponse item) async {
    await _service.write("preference", jsonEncode(item.toJson()));
    return item;
  }
}