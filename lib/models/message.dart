class MessageModel {
  String message;
  bool isSender = false;
  DateTime date;

  MessageModel({
    required this.message,
    required this.isSender,
    DateTime? messageDate,
  }) : date = messageDate ?? DateTime.now();
}
