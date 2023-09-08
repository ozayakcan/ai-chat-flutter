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
    Widget? descriptionWidget,
    double descriptionWidgetTopMargin = 0,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              SizedBox(
                height: descriptionWidgetTopMargin,
              ),
              if (descriptionWidget != null) descriptionWidget,
            ],
          ),
          actions: actions,
        );
      },
    );
  }
}
