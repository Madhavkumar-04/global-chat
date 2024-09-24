import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String uid;
  final String userId;
  final String username;
  final String content;
  final DateTime timestamp; // Ensure it's DateTime
  final String imageUrl;

  ChatMessage({
    required this.uid,
    required this.userId,
    required this.username,
    required this.content,
    required this.timestamp, // DateTime
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'username': username,
      'content': content,
      'timestamp': timestamp, // Store as DateTime
      'imageUrl': imageUrl,
    };
  }

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      uid: json['uid'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
