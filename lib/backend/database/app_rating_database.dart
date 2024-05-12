import 'dart:convert';

import 'package:user/library.dart';

class AppRatingDatabase extends RepositoryService<AppRating, String> {
  final DatabaseService _service = DatabaseImplementation(accountDatabase);

  @override
  Future<Optional<AppRating>> delete(AppRating item) async {
    _service.remove("AppRating");
    return Optional<AppRating>.empty();
  }

  @override
  AppRating get() {
    String? data = _service.read("AppRating");

    if(data != null) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      return AppRating.fromJson(jsonData);
    } else {
      return AppRating.common();
    }
  }

  @override
  Future<AppRating> save(AppRating item) async {
    await _service.write("AppRating", jsonEncode(item.toJson()));
    return item;
  }
}