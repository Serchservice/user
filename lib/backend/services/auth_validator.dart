import 'package:user/library.dart';
import 'package:connectify_flutter/connectify_flutter.dart';

class AuthValidator implements AuthValidatorService {
  final ConnectService _connect = Connect(useToken: false);

  @override
  void validateSession({
    required Function(String success) onSuccess,
    required Function(String error) onError
  }) async {
    String token = Database.session.accessToken;
    String state = Database.address.state;
    String country = Database.address.country;
    ApiResponse response = await _connect.get(endpoint: "/auth/session/validate?token=$token&state=$state&country=$country");
    if(response.isSuccessful) {
      onSuccess.call(response.message);
    } else {
      onError.call(response.message);
    }
  }

  @override
  void fetchAccounts({Function(List<Account> success)? onSuccess, Function(String error)? onError}) async {
    var useToken = Database.isUserActive;

    final ConnectService connect = Connect(useToken: useToken);
    var response = await connect.get(
        endpoint: useToken ? "/account" : "/guest/shared/accounts?id=${Database.guest.id}"
    );
    if(response.isSuccessful && response.data != null) {
      List<dynamic> result = response.data;
      List<Account> account = result.map((e) => Account.fromJson(e)).toList();
      Database.saveAccount(account);
      onSuccess?.call(account);
    } else {
      onError?.call(response.message);
    }
  }
}