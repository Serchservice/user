import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:user/library.dart';

class Connect<T> implements ConnectService<T> {
  final bool useToken;
  final bool showError;

  Connect({this.useToken = true, this.showError = true});

  ConnectifyService get connect {
    Map<String, String> headers = {
      'X-Serch-Signed': Keys.signature
    };

    if(Database.isGuestActive) {
      headers.addAll({
        'Content-Type': 'application/json',
        'X-Serch-Guest-Api-Key': Keys.guestApiKey,
        'X-Serch-Guest-Secret-Key': Keys.guestSecretKey,
      });
    }

    return Connectify(config: ConnectifyConfig(
      useToken: this.useToken,
      baseUrl: "http://192.168.43.153:8080/api/v1",
      mode: Server.PRODUCTION,
      session: Database.session,
      onSessionUpdate: (session) => Database.saveSession(session),
      onRemoveRoutes: () {
        if(!Get.currentRoute.endsWith(EmailCheckerLayout.route)) {
          if(Get.isRegistered<ParentController>()) {
            Get.delete<ParentController>();
          }

          EmailCheckerLayout.all();
        }
      },
      headers: headers
    ));
  }

  @override
  Future<ApiResponse<T>> delete({required String endpoint, Map<String, dynamic>? query, body}) async {
    try {
      var response = await connect.delete(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> get({required String endpoint, Map<String, dynamic>? query}) async {
    try {
      var response = await connect.get(endpoint: endpoint, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> patch({required String endpoint, body, Map<String, dynamic>? query}) async {
    try {
      var response = await connect.patch(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  @override
  Future<ApiResponse<T>> post({required String endpoint, body, Map<String, dynamic>? query,}) async {
    try {
      var response = await connect.post(endpoint: endpoint, body: body, query: query);
      return transformResponse(response);
    } on ConnectifyException catch (e) {
      return handleException(e);
    }
  }

  ApiResponse<T> transformResponse(ApiResponse<dynamic> response) {
    return ApiResponse(
      status: response.status,
      code: response.code,
      message: response.message,
      data: response.data
    );
  }

  ApiResponse<T> handleException(ConnectifyException e) {
    if(showError) {
      notify.error(message: e.message);
    }

    return ApiResponse.error(e.message);
  }
}