import 'package:flutter/material.dart';

PopupMenuItem popupMenuItem(
  BuildContext context, {
  IconData? icon,
  required String text,
  dynamic value,
  VoidCallback? onTap,
}) {
  double iconSize = 20;
  return PopupMenuItem(
    onTap: onTap,
    value: value,
    child: Row(
      children: [
        icon == null
            ? SizedBox(
                width: iconSize,
              )
            : Icon(
                icon,
                size: iconSize,
                color: Theme.of(context).iconTheme.color,
              ),
        const SizedBox(
          width: 5,
        ),
        Text(text),
      ],
    ),
  );
}

void loadingDialog(
  BuildContext context, {
  String? text,
  bool dismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (text != null)
                const SizedBox(
                  height: 10,
                ),
              if (text != null) Text(text),
            ],
          ),
        ),
      );
    },
  );
}
