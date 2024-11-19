import 'package:connectify_flutter/connectify_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:user/library.dart';

class Connect<T> implements ConnectService<T> {
  bool useToken;
  Connect({this.useToken = true});

  Connectify get connect {
    return Connectify(options: ConnectifyOptions(
      useToken: this.useToken,
      showLog: false,
      mode: ConnectifyMode.PRODUCTION,
      session: Database.session,
      onSessionUpdate: (session) => Database.saveSession(session),
      onRemoveRoutes: () {
        if(!Get.currentRoute.endsWith(EmailCheckerLayout.route)) {
          if(Get.isRegistered<HomeController>()) {
            Get.delete<HomeController>();
          }

          Navigate.all(EmailCheckerLayout.route);
        }
      },
      headers: Database.preference.active == Database.guest.id ? {
        'Content-Type': 'application/json',
        'X-Serch-Guest-Api-Key': Keys.guestApiKey,
        'X-Serch-Guest-Secret-Key': Keys.guestSecretKey,
        'X-Serch-Signed': Keys.signature
      } : {
        'X-Serch-Signed': Keys.signature
      },
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
    notify.error(message: e.message);

    return ApiResponse.error(e.message);
  }
}