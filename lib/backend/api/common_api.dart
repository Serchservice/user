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

  @override
  void fetchAccounts({Function(List<Account> success)? onSuccess, Function(String error)? onError}) async {
    final Connect connect = Connect(useToken: Database.guest.id.isEmpty);
    try {
      var res = await connect.get(
        endpoint: Database.guest.id.isNotEmpty
          ? "/guest/shared/accounts?id=${Database.guest.id}"
          : "/account"
      );
      ApiResponse response = ApiResponse.fromJson(res.data);
      if(response.isOk) {
        List<dynamic> result = response.data;
        List<Account> account = result.map((e) => Account.fromJson(e)).toList();
        Database.saveAccount(account);
        onSuccess?.call(account);
      } else {
        onError?.call(response.message);
      }
    } on Exception catch(e) {
      onError?.call(e.toString());
    }
  }
}