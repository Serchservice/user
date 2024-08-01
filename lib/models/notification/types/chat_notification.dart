import 'dart:convert';

class ChatNotification {
  final String roommate;
  final String id;
  final String room;
  final String snt;
  final String image;
  final String category;
  final String summary;

  ChatNotification({
    required this.roommate,
    required this.id,
    required this.room,
    required this.snt,
    required this.image,
    required this.category,
    required this.summary
  });

  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    return ChatNotification(
      roommate: json['roommate'] ?? '',
      id: json['id'] ?? '',
      room: json['room'] ?? '',
      snt: json['snt'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      summary: json['summary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roommate': roommate,
      'id': id,
      'room': room,
      'snt': snt,
      'image': image,
      'category': category,
      'summary': summary,
    };
  }

  ChatNotification copyWith({
    String? roommate,
    String? id,
    String? room,
    String? snt,
    String? image,
    String? category,
    String? summary,
  }) {
    return ChatNotification(
      roommate: roommate ?? this.roommate,
      id: id ?? this.id,
      room: room ?? this.room,
      snt: snt ?? this.snt,
      image: image ?? this.image,
      category: category ?? this.category,
      summary: summary ?? this.summary,
    );
  }

  @override
  String toString() => jsonEncode(this);

  ChatNotification fromString(String source) => jsonDecode(source);
}