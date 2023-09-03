import 'package:aichat/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/message.dart';
import '../utils/ai.dart';
import '../utils/data.dart';
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

  String userID = "";
  List<MessageModel> messages = [];

  bool isLoadingDialogShown = false;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    messages = widget.messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chat $userID"),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              ScaffoldSnackbar scaffoldSnackbar = ScaffoldSnackbar.of(context);
              AppLocalizations appLocalizations = AppLocalizations.of(context);
              switch (value) {
                case 0:
                  showLoadingDialog(
                    appLocalizations.backing_up_messages,
                  );
                  await Data.backupData(
                    scaffoldSnackbar: scaffoldSnackbar,
                    appLocalizations: appLocalizations,
                  );
                  closeLoadingDialog();
                  break;
                case 1:
                  showLoadingDialog(
                    appLocalizations.restoring_messages,
                  );
                  await Data.restoreData(
                    scaffoldSnackbar: scaffoldSnackbar,
                    appLocalizations: appLocalizations,
                    onMessagedRestored: () async {
                      List<MessageModel> allMessages = await MessageModel.get();
                      setState(() {
                        messages = allMessages;
                      });
                    },
                  );
                  closeLoadingDialog();
                  break;
                case 2:
                  showLoadingDialog(
                    appLocalizations.clearing_messages,
                  );
                  Future.delayed(const Duration(seconds: 2), () async {
                    await Data.clearMessages(onCleared: () {
                      setState(() {
                        messages.clear();
                      });
                    });
                    closeLoadingDialog();
                  });
                  break;
                case 3:
                  showLoadingDialog(
                    appLocalizations.clearing_all_data,
                  );
                  Future.delayed(const Duration(seconds: 2), () async {
                    await Data.clearMessages(onCleared: () {
                      setState(() {
                        messages.clear();
                      });
                    });
                    await Data.resetUserID(onResetUserID: (newUserID) {
                      setState(() {
                        userID = newUserID;
                      });
                    });
                    closeLoadingDialog();
                  });
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                popupMenuItem(
                  context,
                  value: 0,
                  icon: Icons.backup,
                  text: AppLocalizations.of(context).backup_messages,
                ),
                popupMenuItem(
                  context,
                  value: 1,
                  icon: Icons.restore,
                  text: AppLocalizations.of(context).restore_messages,
                ),
                popupMenuItem(
                  context,
                  value: 2,
                  icon: Icons.message,
                  text: AppLocalizations.of(context).clear_messages,
                ),
                popupMenuItem(
                  context,
                  value: 3,
                  icon: Icons.clear_all,
                  text: AppLocalizations.of(context).clear_all_data,
                ),
              ];
            },
          )
        ],
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
                          String response =
                              await AI.of(context).sendMessage(userID, text);
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

  void showLoadingDialog(String text) {
    if (!isLoadingDialogShown) {
      loadingDialog(context, text: text, dismissible: false);
      setState(() {
        isLoadingDialogShown = true;
      });
    }
  }

  void closeLoadingDialog() {
    if (isLoadingDialogShown) {
      Navigator.pop(context);
      setState(() {
        isLoadingDialogShown = false;
      });
    }
  }
}
