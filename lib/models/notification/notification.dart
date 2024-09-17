import 'dart:convert';

class Notification<T> {
  final String title;
  final String body;
  final String? image;
  final T? data;
  final String snt;

  Notification({
    required this.title,
    required this.body,
    this.image,
    this.data,
    required this.snt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
      data: json['data'] != null ? jsonDecode(json["data"]) : null,
      snt: json['snt'] ?? '',
    );
  }

  factory Notification.empty() {
    return Notification(
      title: '',
      body: '',
      image: '',
      data: null,
      snt: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'data': data,
      'snt': snt,
    };
  }

  Notification<T> copyWith({
    String? title,
    String? body,
    String? image,
    T? data,
    String? snt,
  }) {
    return Notification(
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      data: data ?? this.data,
      snt: snt ?? this.snt,
    );
  }
}
