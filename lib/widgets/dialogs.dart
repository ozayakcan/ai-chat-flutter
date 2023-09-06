import 'package:flutter/material.dart';

class MyAlertDialog {
  MyAlertDialog._(
    this.context,
  );
  final BuildContext context;

  factory MyAlertDialog.of(BuildContext context) {
    return MyAlertDialog._(context);
  }
  void show({
    required String title,
    required String description,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: actions,
        );
      },
    );
  }
}
