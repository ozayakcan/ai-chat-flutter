import 'dart:math' as math;
import 'package:aichat/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/date.dart';

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.messageModel});

  final MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    final reg = RegExp("(?=<a)|(?<=/a>)");
    var resultMsg = messageModel.message.split(reg);
    List<TextSpan> msgList = [];
    for (var msg in resultMsg) {
      if (msg.startsWith("<a")) {
        RegExp regexHref = RegExp('(?<=href=").*?(?=")');
        var matchHref = regexHref.firstMatch(msg);
        final regexText = RegExp("<[^>]*>");
        var matchText = msg.split(regexText);
        msgList.add(
          TextSpan(
            text: matchText[1],
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                String url = matchHref!.group(0)!;
                if (!await launchUrl(Uri.parse(url))) {
                  if (kDebugMode) {
                    print("Could not launch url: $url");
                  }
                }
              },
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
            ),
          ),
        );
      } else {
        msgList.add(
          TextSpan(
            text: msg,
            style: TextStyle(
              color: messageModel.isAI ? Colors.black : Colors.white,
              fontSize: 14,
            ),
          ),
        );
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: messageModel.selected
            ? BoxDecoration(color: Colors.cyan.withAlpha(50))
            : null,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(right: 18.0, left: 50, top: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: messageModel.isAI
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: messageModel.isAI
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                crossAxisAlignment: messageModel.isAI
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  if (messageModel.isAI)
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: CustomPaint(
                        painter: CustomShape(Colors.grey),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 14,
                      right: 14,
                      left: 14,
                    ),
                    decoration: BoxDecoration(
                      color: messageModel.isAI ? Colors.grey : Colors.cyan,
                      borderRadius: BorderRadius.only(
                        topLeft: messageModel.isAI
                            ? Radius.zero
                            : const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: const Radius.circular(18),
                        bottomRight: messageModel.isAI
                            ? const Radius.circular(18)
                            : Radius.zero,
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: msgList,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 2),
                            child: Text(
                              DateFormat("kk:mm").format(messageModel.date),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: messageModel.isAI
                                    ? Colors.black.withAlpha(200)
                                    : Colors.white.withAlpha(200),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!messageModel.isAI)
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: CustomPaint(
                        painter: CustomShape(Colors.cyan),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageDateWidget extends StatelessWidget {
  const MessageDateWidget({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Colors.blue,
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          getDateString(context, date),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
