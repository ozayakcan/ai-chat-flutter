import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../models/message.dart';
import '../utils/ai.dart';
import '../utils/data.dart';
import '../utils/date.dart';
import '../utils/github.dart';
import '../utils/shared_preferences.dart';
import '../widgets/dialogs.dart';
import '../widgets/message.dart';
import '../widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.packageInfo,
    required this.userID,
    required this.messages,
  });

  final PackageInfo packageInfo;
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

  bool messagesSelected = false;

  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    messages = widget.messages;
    Future.delayed(Duration.zero, () async {
      await Github.checkUpdates(context, version: widget.packageInfo.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    ScaffoldSnackbar scaffoldSnackbar = ScaffoldSnackbar.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packageInfo.appName),
        actions: [
          if (messagesSelected)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await copyMessages(appLocalizations, scaffoldSnackbar);
              },
            ),
          if (messagesSelected)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await shareMessages(appLocalizations, scaffoldSnackbar);
              },
            ),
          if (messagesSelected)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await deleteMessages(
                  context,
                  appLocalizations,
                  scaffoldSnackbar,
                );
              },
            ),
          PopupMenuButton(
            onSelected: (value) async {
              MyAlertDialog myAlertDialog = MyAlertDialog.of(context);
              switch (value) {
                case 0:
                  if (await Github.checkUpdates(context,
                          version: widget.packageInfo.version) ==
                      null) {
                    myAlertDialog.show(
                      title: appLocalizations.up_to_date,
                      description: appLocalizations.up_to_date_desc,
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(appLocalizations.close),
                        )
                      ],
                    );
                  }
                  break;
                case 1:
                  await backupData(appLocalizations, scaffoldSnackbar);
                  break;
                case 2:
                  restoreData(
                    appLocalizations,
                    scaffoldSnackbar,
                    myAlertDialog,
                  );
                  break;
                case 3:
                  clearMessages(
                    appLocalizations,
                    scaffoldSnackbar,
                    myAlertDialog,
                  );
                  break;
                case 4:
                  clearAllData(
                    appLocalizations,
                    scaffoldSnackbar,
                    myAlertDialog,
                  );
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return [
                popupMenuItem(
                  context,
                  value: 0,
                  icon: Icons.cloud,
                  text: appLocalizations.check_updates,
                ),
                popupMenuItem(
                  context,
                  value: 1,
                  icon: Icons.backup,
                  text: appLocalizations.backup_data,
                ),
                popupMenuItem(
                  context,
                  value: 2,
                  icon: Icons.restore,
                  text: appLocalizations.restore_data,
                ),
                popupMenuItem(
                  context,
                  value: 3,
                  icon: Icons.message,
                  text: appLocalizations.clear_messages,
                ),
                popupMenuItem(
                  context,
                  value: 4,
                  icon: Icons.clear_all,
                  text: appLocalizations.clear_all_data,
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
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: () {
                              if (messagesSelected) {
                                selectMessage(i);
                              }
                            },
                            onLongPress: () {
                              selectMessage(i);
                            },
                            child: MessageWidget(
                              messageModel: messages[i],
                            ),
                          ),
                        ],
                      ),
                    if (isTyping)
                      MessageWidget(
                        messageModel: MessageModel.empty(isAI: true),
                        isTyping: true,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
              child: SizedBox(
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        autofocus: true,
                        controller: textEditingController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (val) async {
                          await sendMessage(appLocalizations);
                        },
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: appLocalizations.type_something,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () async {
                        await sendMessage(appLocalizations);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        size: 30,
                      )),
                    )
                  ],
                ),
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

  sendMessage(AppLocalizations appLocalizations) async {
    String text = textEditingController.text;
    textEditingController.text = "";
    if (text.isNotEmpty) {
      try {
        setState(() {
          messages.add(
            MessageModel(
              realMessage: text,
              isAI: false,
            ),
          );
          isTyping = true;
        });
        String response = await AI.of(context).sendMessage(userID, text);
        setState(() {
          messages.add(
            MessageModel(
              realMessage: response,
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
              realMessage: appLocalizations.an_error_occurred,
              isAI: true,
            ),
          );
        });
      } finally {
        focusNode.requestFocus();
        setState(() {
          isTyping = false;
        });
        await MessageModel.save(messages);
      }
    }
  }

  void selectMessage(int i) {
    setState(() {
      messages[i].selected = !messages[i].selected;
    });
    int selectedMessageIndex =
        messages.indexWhere((element) => element.selected == true);
    setState(() {
      messagesSelected = selectedMessageIndex >= 0;
    });
  }

  List<MessageModel> getSelectedMessages() {
    List<MessageModel> selectedMessages =
        messages.where((element) => element.selected).toList();

    if (selectedMessages.isEmpty) {
      return [];
    } else {
      return selectedMessages;
    }
  }

  String? getSelectedMessagesAsString(AppLocalizations appLocalizations) {
    List<MessageModel> selectedMessages =
        messages.where((element) => element.selected).toList();
    String text = "";
    if (selectedMessages.isEmpty) {
      return null;
    } else if (selectedMessages.length == 1) {
      text = selectedMessages.first.message;
    } else {
      for (var msg in selectedMessages) {
        String dateFormat =
            DateFormat(appLocalizations.date_format_full).format(msg.date);
        text += msg.isAI
            ? appLocalizations.message_ai(dateFormat, msg.message)
            : appLocalizations.message_you(dateFormat, msg.message);
      }
    }
    return text;
  }

  copyMessages(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
  ) async {
    String? selectedMessages = getSelectedMessagesAsString(appLocalizations);
    if (selectedMessages != null) {
      await Clipboard.setData(ClipboardData(text: selectedMessages));

      setState(() {
        messagesSelected = false;
      });

      for (int i = 0; i < messages.length; i++) {
        if (messages[i].selected) {
          setState(() {
            messages[i].selected = false;
          });
        }
      }
      scaffoldSnackbar.show(appLocalizations.messages_copied);
    } else {
      scaffoldSnackbar.show(appLocalizations.no_message_selected);
    }
  }

  shareMessages(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
  ) async {
    String? selectedMessages = getSelectedMessagesAsString(appLocalizations);
    if (selectedMessages != null) {
      await Share.share(
        selectedMessages,
        subject:
            appLocalizations.messages_share_title(widget.packageInfo.appName),
      );
    } else {
      scaffoldSnackbar.show(appLocalizations.no_message_selected);
    }
  }

  deleteMessages(
    BuildContext context,
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
  ) {
    MyAlertDialog.of(context).show(
      title: appLocalizations.delete_messages,
      description: appLocalizations.delete_messages_desc,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showLoadingDialog(appLocalizations.deleting_messages);
            Future.delayed(const Duration(seconds: 2), () {
              List<MessageModel> selectedMessages = getSelectedMessages();
              if (selectedMessages.isNotEmpty) {
                for (var msg in selectedMessages) {
                  setState(() {
                    messages.removeWhere((element) => element.id == msg.id);
                  });
                }
                setState(() {
                  messagesSelected = false;
                });
                MessageModel.save(messages);
              } else {
                scaffoldSnackbar.show(appLocalizations.no_message_selected);
              }
              closeLoadingDialog();
            });
          },
          child: Text(appLocalizations.yes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(appLocalizations.no),
        ),
      ],
    );
  }

  backupData(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
  ) async {
    showLoadingDialog(
      appLocalizations.backing_up_data,
    );
    await Data.backupData(
      appName: widget.packageInfo.appName,
      scaffoldSnackbar: scaffoldSnackbar,
      appLocalizations: appLocalizations,
    );
    closeLoadingDialog();
  }

  restoreData(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
    MyAlertDialog myAlertDialog,
  ) {
    myAlertDialog.show(
      title: appLocalizations.restore_data,
      description: appLocalizations.restore_data_alert_desc,
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            showLoadingDialog(
              appLocalizations.restoring_data,
            );
            await Data.restoreData(
              scaffoldSnackbar: scaffoldSnackbar,
              appLocalizations: appLocalizations,
              onRestored: (keyList) async {
                for (final key in keyList) {
                  if (key == SharedPreference.messagesString) {
                    List<MessageModel> allMessages = await MessageModel.get();
                    setState(() {
                      messages = allMessages;
                    });
                  } else if (key == SharedPreference.userID) {
                    String? oldUserID = await SharedPreference.getString(
                        SharedPreference.userID);
                    if (oldUserID != null) {
                      setState(() {
                        userID = oldUserID;
                      });
                    }
                  }
                }
              },
            );
            closeLoadingDialog();
          },
          child: Text(appLocalizations.yes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(appLocalizations.no),
        ),
      ],
    );
  }

  clearMessages(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackBar,
    MyAlertDialog myAlertDialog,
  ) {
    myAlertDialog.show(
      title: appLocalizations.clear_messages,
      description: appLocalizations.clear_messages_desc,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showLoadingDialog(
              appLocalizations.clearing_messages,
            );
            Future.delayed(const Duration(seconds: 2), () async {
              await Data.clearMessages(
                onCleared: () {
                  setState(() {
                    messages.clear();
                  });
                },
              );
              closeLoadingDialog();
              scaffoldSnackBar.show(appLocalizations.messages_cleared);
            });
          },
          child: Text(appLocalizations.yes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(appLocalizations.no),
        ),
      ],
    );
  }

  clearAllData(
    AppLocalizations appLocalizations,
    ScaffoldSnackbar scaffoldSnackbar,
    MyAlertDialog myAlertDialog,
  ) {
    myAlertDialog.show(
      title: appLocalizations.clear_all_data,
      description: appLocalizations.clear_all_data_desc,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);

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
              scaffoldSnackbar.show(appLocalizations.data_cleared);
            });
          },
          child: Text(appLocalizations.yes),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(appLocalizations.no),
        ),
      ],
    );
  }
}
