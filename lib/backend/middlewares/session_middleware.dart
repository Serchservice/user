import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class SessionMiddleware extends GetMiddleware{
  final AuthValidatorService _apiService = AuthValidator();

  int? _priority = 0;

  @override
  int? get priority => _priority;

  @override
  set priority(int? value) {
    _priority = value;
  }

  SessionMiddleware({
    required int? priority
  }) : _priority = priority;

  @override
  RouteSettings? redirect(String? route) {
    bool isSuccess = false;

    _apiService.validateSession(
      onSuccess: (message) {
        isSuccess = true;
      },
      onError: (error) {
        isSuccess = false;
      }
    );

    if(isSuccess) {
      return null;
    } else {
      return const RouteSettings(name: EmailCheckerLayout.route);
    }
  }
}