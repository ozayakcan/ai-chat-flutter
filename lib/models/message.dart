import 'dart:convert';

import '../utils/shared_preferences.dart';

class MessageModel {
  String message;
  bool isAI = false;
  DateTime date;

  MessageModel({
    required this.message,
    required this.isAI,
    DateTime? messageDate,
  }) : date = messageDate ?? DateTime.now();

  static String get messageStr => "message";
  static String get isAIStr => "isAI";
  static String get dateStr => "date";

  static MessageModel fromJson(Map data) {
    int? dateTimeInt = data[dateStr] as int?;
    bool? isAIBool = bool.tryParse((data[isAIStr] as String?) ?? "false");
    return MessageModel(
      message: (data[messageStr] as String?) ?? "",
      isAI: isAIBool ?? true,
      messageDate: dateTimeInt != null
          ? DateTime.fromMillisecondsSinceEpoch(dateTimeInt)
          : DateTime.now(),
    );
  }

  Map toJson() {
    return {
      messageStr: message,
      isAIStr: isAI.toString(),
      dateStr: date.millisecondsSinceEpoch,
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
