import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:user/library.dart';

class Connect extends Interceptor {
  bool useToken;
  Connect({this.useToken = true});

  Dio get connect {
    var headers = Database.isLoggedIn && useToken
      ? Map.of({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Database.session.accessToken}'
      })
      : Map.of({'Accept': 'application/json'});

    if (!kIsWeb) {
      headers.putIfAbsent("Content-Type", () => "application/json");
    }

    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        baseUrl: Keys.baseUrl,
        headers: headers,
        contentType: Headers.jsonContentType,
      ),
    )..interceptors.add(this);
  }

  Future<String?> refreshToken() async {
    Dio dio = Dio();

    String? token;
    await dio.get(
      "${Keys.baseUrl}/auth/session/refresh?token=${Database.session.accessToken}",
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    ).then((value) {
      ApiResponse<Session> response = ApiResponse.fromJson(value.data);
      if(response.isOk && response.data != null) {
        Database.saveSession(response.data!);
        token = response.data!.accessToken;
      }
    }).catchError((error) {
      Logger.log(error);
      return null;
    });
    return token;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if(err.type == DioExceptionType.connectionTimeout) {
      SnackBars.top(
        message: "Connection timed out. Check your network and try again",
        type: Snackbar.error
      );
    }
    if (err.response?.statusCode == 401) {
      refreshToken().then((newToken) {
        if(newToken != null) {
          Logger.log("Retrying...");
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          handler.resolve(err.response!);
          handler.next(err);
        } else {
          throw SerchException(
            "Cannot continue with request. You will be redirected to login",
            isSessionExpired: true
          );
        }
      }).catchError((error) {
        handler.reject(err);
      });
    } else {
      handler.next(err);
    }
  }

  Future<Response> post({
    required String endpoint,
    required dynamic body,
    Map<String, dynamic>? query,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress
  }) => connect.post(
    endpoint,
    data: body,
    queryParameters: query,
    onReceiveProgress: onReceiveProgress,
    onSendProgress: onSendProgress
  );

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? query,
    void Function(int, int)? onReceiveProgress
  }) => connect.get(
    endpoint,
    queryParameters: query,
    onReceiveProgress: onReceiveProgress
  );

  Future<Response> patch({
    required String endpoint,
    required dynamic body,
    Map<String, dynamic>? query,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress
  }) => connect.patch(
    endpoint,
    data: body,
    queryParameters: query,
    onReceiveProgress: onReceiveProgress,
    onSendProgress: onSendProgress
  );

  Future<Response> delete({
    required String endpoint,
    Map<String, dynamic>? query,
    dynamic body,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress
  }) => connect.delete(
    endpoint,
    data: body,
    queryParameters: query
  );
}