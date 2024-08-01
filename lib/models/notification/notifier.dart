class Notifier {
  final int notification;
  final String id;

  Notifier({required this.notification, required this.id});

  Notifier copyWith({int? notification, String? id}) {
    return Notifier(notification: notification ?? this.notification, id: id ?? this.id);
  }
}