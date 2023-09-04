import 'dart:convert';

import '../utils/shared_preferences.dart';
import '../utils/text.dart';

class MessageModel {
  String id;
  String realMessage;
  bool isAI = false;
  DateTime date;

  String get message {
    RegExp tipsRegExp = RegExp("<tips>(.+?)</tips>");
    return realMessage.replaceAll(tipsRegExp, "");
  }

  MessageModel({
    required this.realMessage,
    required this.isAI,
    String? messageID,
    DateTime? messageDate,
  })  : id = messageID ?? getRandomString(15),
        date = messageDate ?? DateTime.now();

  static String get idStr => "id";
  static String get messageStr => "message";
  static String get isAIStr => "isAI";
  static String get dateStr => "date";

  static MessageModel fromJson(Map data) {
    int? dateTimeInt = data[dateStr] as int?;
    bool? isAIBool = bool.tryParse((data[isAIStr] as String?) ?? "false");
    return MessageModel(
      messageID: (data[idStr] as String?) ?? "",
      realMessage: (data[messageStr] as String?) ?? "",
      isAI: isAIBool ?? true,
      messageDate: dateTimeInt != null
          ? DateTime.fromMillisecondsSinceEpoch(dateTimeInt)
          : DateTime.now(),
    );
  }

  Map toJson() {
    return {
      idStr: id,
      messageStr: realMessage,
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
