class Notification {
  final String title;
  final String body;
  final String? image;

  Notification({
    required this.title,
    required this.body,
    this.image,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'image': image,
    };
  }

  Notification copyWith({
    String? title,
    String? body,
    String? image,
  }) {
    return Notification(
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
    );
  }
}