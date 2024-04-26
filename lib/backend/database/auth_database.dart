import 'dart:convert';

import 'package:user/library.dart';

String authDatabase = "AUTH_DATABASE";

class AuthDatabase extends RepositoryService<AuthResponse, Session> {
  final DatabaseService _service = DatabaseImplementation(authDatabase);

  @override
  Future<Optional<AuthResponse>> delete(AuthResponse item) async {
    if(get().firstName != "") {
      _service.remove("auth");
    }
    return Optional<AuthResponse>.empty();
  }

  @override
  AuthResponse get() {
    String? data = _service.read("auth");

    if(data != null) {
      return AuthResponse.fromJson(jsonDecode(data));
    } else {
      return AuthResponse.empty();
    }
  }

  @override
  Future<AuthResponse> save(AuthResponse item) async {
    await _service.write("auth", jsonEncode(item.toJson()));
    return item;
  }
}