import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrivateChatModel {
  final List<String> friendKeys;
  PrivateChatModel({
    required this.friendKeys,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'friendKeys': friendKeys,
    };
  }

  factory PrivateChatModel.fromMap(Map<String, dynamic> map) {
    return PrivateChatModel(
      friendKeys: List<String>.from(map['friendKeys'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivateChatModel.fromJson(String source) =>
      PrivateChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
