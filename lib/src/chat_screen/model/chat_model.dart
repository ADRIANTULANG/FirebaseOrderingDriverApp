// To parse this JSON data, do
//
//     final ChatDriverModel = ChatDriverModelFromJson(jsonString);

import 'dart:convert';

List<ChatDriverModel> chatDriverModelFromJson(String str) =>
    List<ChatDriverModel>.from(
        json.decode(str).map((x) => ChatDriverModel.fromJson(x)));

String chatDriverModelToJson(List<ChatDriverModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatDriverModel {
  String id;
  String sender;
  String message;
  DateTime date;

  ChatDriverModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.date,
  });

  factory ChatDriverModel.fromJson(Map<String, dynamic> json) =>
      ChatDriverModel(
        id: json["id"],
        sender: json["sender"],
        message: json["message"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "message": message,
        "date": date.toIso8601String(),
      };
}
