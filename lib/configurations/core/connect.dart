import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:user/library.dart';

class Connect<T> extends Interceptor implements ConnectService<T> {
  bool useToken;
  Connect({this.useToken = true});

  Map<String, String> getHeader() {
    if (Database.isLoggedIn && useToken) {
      return {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Database.session.accessToken}',
      };
    } else {
      return {'Accept': 'application/json'};
    }
  }

  Dio get connect {
    var headers = getHeader();

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
    try {
      var response = await dio.get(
        "${Keys.baseUrl}/auth/session/refresh?token=${Database.session.accessToken}",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      if(response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 299)) {
        ApiResponse<SessionResponse> apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.isOk && apiResponse.data != null) {
          Database.saveSession(apiResponse.data!);
          token = apiResponse.data!.accessToken;
        }
      }
    } catch (error) {
      if (error is String) {
        notify.error(message: error);
      } else if (error is List<String>) {
        for (var value in error) {
          notify.error(message: value);
        }
      } else if (error is Map<String, dynamic> && error.containsKey('message')) {
        notify.error(message: error['message']);
      } else {
        notify.error(message: "An error occurred while performing request. Try again shortly.");
      }
    }
    return token;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      notify.error(message: "Connection timed out. Check your network and try again");
    } else if (err.response?.statusCode == 401) {
      refreshToken().then((newToken) {
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          handler.resolve(err.response!);
          handler.next(err);
        } else {
          throw SerchException(
              "Cannot continue with request. You will be redirected to login",
              isSessionExpired: true);
        }
      }).catchError((error) {
        handler.reject(err);
      });
    } else {
      handler.next(err);
    }
  }

  @override
  Future<ApiResponse<T>> delete({
    required String endpoint,
    Map<String, dynamic>? query,
    body,
  }) async {
    try {
      var response = await connect.delete(
        endpoint,
        data: body,
        queryParameters: query,
      );
      return transformResponse(response);
    } on DioException catch (e) {
      return handleDioException(e);
    }
  }

  @override
  Future<ApiResponse<T>> get({
    required String endpoint,
    Map<String, dynamic>? query,
    void Function(int p1, int p2)? onReceiveProgress,
  }) async {
    try {
      var response = await connect.get(
          endpoint,
          queryParameters: query,
          onReceiveProgress: onReceiveProgress,
          cancelToken: CancelTokenManager.cancelToken
      );
      return transformResponse(response);
    } on DioException catch (e) {
      return handleDioException(e);
    }
  }

  @override
  Future<ApiResponse<T>> patch({
    required String endpoint,
    body,
    Map<String, dynamic>? query,
    void Function(int p1, int p2)? onSendProgress,
    void Function(int p1, int p2)? onReceiveProgress,
  }) async {
    try {
      var response = await connect.patch(
          endpoint,
          data: body,
          queryParameters: query,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          cancelToken: CancelTokenManager.cancelToken
      );
      return transformResponse(response);
    } on DioException catch (e) {
      return handleDioException(e);
    }
  }

  @override
  Future<ApiResponse<T>> post({
    required String endpoint,
    body,
    Map<String, dynamic>? query,
    void Function(int p1, int p2)? onSendProgress,
    void Function(int p1, int p2)? onReceiveProgress,
  }) async {
    try {
      var response = await connect.post(
          endpoint,
          data: body,
          queryParameters: query,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          cancelToken: CancelTokenManager.cancelToken
      );
      return transformResponse(response);
    } on DioException catch (e) {
      return handleDioException(e);
    }
  }

  ApiResponse<T> transformResponse(Response response) {
    if (response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! <= 299)) {
      ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(response.data);
      if (apiResponse.isSuccessful) {
        return apiResponse;
      } else {
        return apiResponse;
      }
    } else {
      notify.error(message: response.statusMessage ?? "Couldn't complete request. An error occurred");
    }
    return ApiResponse(
        status: "",
        code: response.statusCode ?? 400,
        message: response.statusMessage ?? "An error occurred"
    );
  }

  ApiResponse<T> handleDioException(DioException e) {
    log(e, from: "Error trace in Connect");
    ApiResponse<T> response;

    if(e.response != null) {
      try {
        response = ApiResponse<T>.fromJson(e.response?.data);
      } catch (_) {
        response = ApiResponse<T>(
            status: "",
            code: e.response?.statusCode ?? 400,
            message: "Network connection failed. Check your internet connection"
        );
      }
    } else {
      response = ApiResponse<T>(
          status: "",
          code: e.response?.statusCode ?? 400,
          message: "An error occurred while sending your request. If this continues, contact support"
      );
    }

    if((response.status == "FORBIDDEN" && response.code == 403) && !Get.currentRoute.endsWith(EmailCheckerLayout.route)) {
      CancelTokenManager.cancelAllRequests();
      if(Get.isRegistered<HomeController>()) {
        Get.delete<HomeController>();
      }

      Navigate.all(EmailCheckerLayout.route);
    }

    return response;
  }
}

class CancelTokenManager {
  static CancelToken cancelToken = CancelToken();

  static void cancelAllRequests() {
    cancelToken.cancel("Operation cancelled");
    cancelToken = CancelToken(); // Reinitialize the token after cancellation
  }
}