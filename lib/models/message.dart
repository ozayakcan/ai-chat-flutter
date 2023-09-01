import 'dart:convert';

import '../utils/shared_preferences.dart';

class MessageModel {
  String message;
  bool isSender = false;
  DateTime date;

  MessageModel({
    required this.message,
    required this.isSender,
    DateTime? messageDate,
  }) : date = messageDate ?? DateTime.now();

  static MessageModel fromJson(Map data) {
    int? dateTimeInt = data["date"] as int?;
    bool? isSenderBool = bool.tryParse((data["isSender"] as String?) ?? "true");
    return MessageModel(
      message: (data["message"] as String?) ?? "",
      isSender: isSenderBool ?? true,
      messageDate: dateTimeInt != null
          ? DateTime.fromMillisecondsSinceEpoch(dateTimeInt)
          : DateTime.now(),
    );
  }

  Map toJson() {
    return {
      "message": message,
      "isSender": isSender.toString(),
      "date": date.millisecondsSinceEpoch,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Future<List<MessageModel>> get() async {
    List<String> list =
        await SharedPreference.getStringList(SharedPreference.messagesString);
    return list.map((e) => MessageModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> save(List<MessageModel> messages) async {
    List<String> list = messages.map((e) => e.toJsonString()).toList();
    return await SharedPreference.setStringList(
        SharedPreference.messagesString, list);
  }
}
