import 'dart:convert';

import 'package:user/library.dart';

class AuthRepository extends RepositoryService<AuthResponse, SessionResponse> {
  final DatabaseService _service = DatabaseImplementation(authDatabase);

  @override
  Future<Optional<AuthResponse>> delete(AuthResponse item) async {
    if(get().firstName != "") {
      _service.remove("Auth");
    }
    return Optional<AuthResponse>.empty();
  }

  @override
  AuthResponse get() {
    String? data = _service.read("Auth");

    if(data != null) {
      return AuthResponse.fromJson(jsonDecode(data));
    } else {
      return AuthResponse.empty();
    }
  }

  @override
  Future<AuthResponse> save(AuthResponse item) async {
    await _service.write("Auth", jsonEncode(item.toJson()));
    return item;
  }
}