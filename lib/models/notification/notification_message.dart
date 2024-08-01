import 'package:user/library.dart';

class NotificationMessage<T> {
  final String token;
  final Notification notification;
  final T? data;
  final NotificationAndroid android;

  NotificationMessage({
    required this.token,
    required this.notification,
    this.data,
    NotificationAndroid? android,
  }) : android = android ?? NotificationAndroid();

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      token: json['token'],
      notification: Notification.fromJson(json['notification']),
      data: json['data'],
      android: json['android'] != null ? NotificationAndroid.fromJson(json['android']) : NotificationAndroid(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': this.token,
      'notification': this.notification.toJson(),
      'data': this.data,
      'android': this.android.toJson(),
    };
  }

  NotificationMessage<T> copyWith({
    String? token,
    Notification? notification,
    T? data,
    NotificationAndroid? android,
  }) {
    return NotificationMessage(
      token: token ?? this.token,
      notification: notification ?? this.notification,
      data: data ?? this.data,
      android: android ?? this.android,
    );
  }
}