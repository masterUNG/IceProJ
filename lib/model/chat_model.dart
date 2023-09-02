// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String message;
  final Timestamp timestamp;
  final Map<String, dynamic> mapSender;
  ChatModel({
    required this.message,
    required this.timestamp,
    required this.mapSender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'timestamp': timestamp,
      'mapSender': mapSender,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      message: (map['message'] ?? '') as String,
      timestamp:(map['timestamp'] ?? Timestamp(0, 0)),
      mapSender: Map<String, dynamic>.from(map['mapSender'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
