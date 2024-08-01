import 'package:user/library.dart';

class ApiResponse<T> {
  String status;
  int code;
  String message;
  T? data;

  ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data
  });

  /// Returns true if the HTTP status code is 200 (OK)
  bool get isOk => code == 200 || isCreated;

  /// Returns true if the HTTP status code is 201 (Created)
  bool get isCreated => code == 201;

  /// Checks if response is successful
  bool get isSuccessful => code >= 200 && code <= 299;

  /// Returns true if the error code indicates an expired session
  bool get isExpiredSession => data != null && data == "S10";

  /// Returns true if the error data indicates an incorrect token
  bool get isIncorrectToken => data != null && data == "S20";

  /// Returns true if the error data indicates access is denied
  bool get isAccessDenied => data != null && data == "S50";

  /// Returns true if the error data indicates that the user was not found
  bool get isUserNotFound => data != null && data == "S40";

  /// Returns true if the error data indicates that the email is not verified
  bool get isEmailNotVerified => data != null && data == "S80";

  /// Returns true if the error data indicates that the profile is not set
  bool get isProfileNotSet => data != null && data == "S90";

  /// Returns true if the error data indicates that the category is not set
  bool get isCategoryNotSet => data != null && data == "S96";

  /// Returns true if the error data indicates that the account is disabled
  bool get isAccountDisabled => data != null && data == "S12";

  /// Returns true if the error data indicates that the account is locked
  bool get isAccountLocked => data != null && data == "S11";

  /// Active guest trip
  bool get isGuestOnTrip => data != null && data == "S111";

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    ApiResponse<T> response = ApiResponse(
      status: json['status'] ?? "",
      code: json['code'] ?? 400,
      message: json['message'] ?? "Couldn't validate request",
      data: json['data'],
    );

    if (response.isAccountDisabled || response.isAccountLocked) {
      throw SerchException(response.message, isLocked: true);
    }

    return response;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}