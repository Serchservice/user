import 'package:dio/dio.dart';
import 'package:user/library.dart';

class CommonApi implements CommonApiService {
  final Connect _connect = Connect(useToken: false);

  @override
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  }) async {
    String token = Database.session.accessToken;
    try {
      Response<dynamic> response = await _connect.get(endpoint: "/auth/session/validate?token=$token");
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if(apiResponse.isOk) {
        onSuccess.call(apiResponse.message);
      } else {
        onError.call(apiResponse.message);
      }
    } on Exception catch (_) {
      onError.call("Couldn't validate your session. You will redirected to login");
    }
  }
}