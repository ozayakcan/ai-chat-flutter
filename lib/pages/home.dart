import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/message.dart';
import '../utils/ai.dart';
import '../utils/date.dart';
import '../widgets/message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.userID, required this.messages});

  final String userID;
  final List<MessageModel> messages;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    messages = widget.messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                controller: scrollController,
                child: Column(
                  children: [
                    for (int i = 0; i < messages.length; i++)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (i > 0)
                            if (getDateString(context, messages[i].date) !=
                                getDateString(context, messages[i - 1].date))
                              MessageDateWidget(date: messages[i].date),
                          if (i == 0) MessageDateWidget(date: messages[i].date),
                          MessageWidget(
                            messageModel: messages[i],
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      autofocus: true,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: AppLocalizations.of(context).type_something,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (textEditingController.text.isNotEmpty) {
                        try {
                          String text = textEditingController.text;
                          setState(() {
                            messages.add(
                              MessageModel(
                                message: text,
                                isAI: false,
                              ),
                            );
                          });
                          String response = await AI
                              .of(context)
                              .sendMessage(widget.userID, text);
                          setState(() {
                            messages.add(
                              MessageModel(
                                message: response,
                                isAI: true,
                              ),
                            );
                          });
                          scrollController.animateTo(
                            0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 300),
                          );
                        } catch (e) {
                          if (kDebugMode) {
                            print("Message Error: $e");
                          }
                          setState(() {
                            messages.add(
                              MessageModel(
                                message: AppLocalizations.of(context)
                                    .an_error_occurred,
                                isAI: false,
                              ),
                            );
                          });
                        } finally {
                          textEditingController.text = "";
                          focusNode.requestFocus();
                          await MessageModel.save(messages);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
