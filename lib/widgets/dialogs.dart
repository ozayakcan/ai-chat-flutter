import 'package:flutter/material.dart';

class MyAlertDialog {
  MyAlertDialog._(
    this.context,
  );
  final BuildContext context;

  factory MyAlertDialog.of(BuildContext context) {
    return MyAlertDialog._(context);
  }
  bool _isShown = false;
  void show({
    required String title,
    required String description,
    List<Widget>? actions,
  }) {
    if (!_isShown) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: actions,
          );
        },
      );
      _isShown = true;
    }
  }

  void close() {
    if (_isShown) {
      Navigator.pop(context);
      _isShown = false;
    }
  }
}
