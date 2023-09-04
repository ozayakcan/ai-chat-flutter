import 'dart:convert';

import 'package:aichat/utils/encryption.dart';
import 'package:aichat/utils/platform.dart';
import 'package:aichat/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import '../models/message.dart';
import 'shared_preferences.dart';
import 'text.dart';

typedef OnUserIDChanged = Function(String newUserID);
typedef OnRestored = Function(List<String> keyList);

class Data {
  static String get _extension => "oacb";

  static Future<void> clearMessages({required VoidCallback onCleared}) async {
    await MessageModel.save([]);
    onCleared.call();
  }

  static Future<void> resetUserID({
    required OnUserIDChanged onResetUserID,
  }) async {
    String newUserID = getRandomString(10);
    await SharedPreference.setString(SharedPreference.userID, newUserID);
    onResetUserID.call(newUserID);
  }

  static Future<void> backupData({
    required ScaffoldSnackbar scaffoldSnackbar,
    required AppLocalizations appLocalizations,
  }) async {
    String backupfileName = "ai_chat_backup.$_extension";
    final Directory directory = await getApplicationDocumentsDirectory();
    Map<String, dynamic> data = {
      "data": "AI Chat",
    };
    Set<String> keys = await SharedPreference.getKeys();
    for (var key in keys) {
      dynamic value = await SharedPreference.get(key);
      if (value != null) {
        data.addAll({
          key: value,
        });
      }
    }
    if (ThisPlatform.get == Platforms.mobile) {
      final File file = File('${directory.path}/$backupfileName');
      await file.writeAsString(Encryption.encrypt(jsonEncode(data)));
      if (!await FlutterFileDialog.isPickDirectorySupported()) {
        if (kDebugMode) {
          print("Picking directory not supported");
        }
        scaffoldSnackbar.show(appLocalizations.this_operation_is_not_supported);
        return;
      }

      final pickedDirectory = await FlutterFileDialog.pickDirectory();

      if (pickedDirectory != null) {
        await FlutterFileDialog.saveFileToDirectory(
          directory: pickedDirectory,
          data: file.readAsBytesSync(),
          mimeType: _extension,
          fileName: backupfileName,
          replace: true,
        );
      } else {
        scaffoldSnackbar.show(appLocalizations.backing_up_data_cancelled);
      }
    } else if (ThisPlatform.get == Platforms.desktop) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: appLocalizations.select_save_directory,
        fileName: backupfileName,
      );

      if (outputFile != null) {
        File file = File(outputFile);
        file.writeAsStringSync(Encryption.encrypt(jsonEncode(data)));
      } else {
        scaffoldSnackbar.show(appLocalizations.backing_up_data_cancelled);
      }
    } else {
      scaffoldSnackbar.show(appLocalizations.this_operation_is_not_supported);
    }
  }

  static Future<void> restoreData({
    required ScaffoldSnackbar scaffoldSnackbar,
    required AppLocalizations appLocalizations,
    required OnRestored onRestored,
  }) async {
    if (ThisPlatform.get == Platforms.mobile ||
        ThisPlatform.get == Platforms.desktop) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: [
          _extension,
        ],
        type: FileType.custom,
      );
      if (result != null) {
        try {
          File file = File(result.files.single.path!);
          String resultStr = Encryption.decrypt(file.readAsStringSync());
          Map<String, dynamic> map = jsonDecode(resultStr);
          String? data = map["data"] as String?;
          if (data != null) {
            List<String> keyList = [];
            for (var key in map.keys) {
              if (key != "data") {
                dynamic value = map[key];
                if (key == SharedPreference.messagesString) {
                  List<dynamic> oldMessagesString = value as List;
                  List<MessageModel> currentMessages = await MessageModel.get();
                  List<MessageModel> oldMessages = oldMessagesString
                      .map((e) => MessageModel.fromJson(jsonDecode(e)))
                      .toList();
                  for (int i = oldMessages.length - 1; i >= 0; i--) {
                    int findIndex = currentMessages.indexWhere(
                        (element) => element.id == oldMessages[i].id);
                    if (findIndex == -1) {
                      currentMessages.insert(0, oldMessages[i]);
                    }
                  }
                  await MessageModel.save(currentMessages);
                  if (kDebugMode) {
                    print("Messages: ${oldMessagesString.toString()}");
                  }
                  keyList.add(key);
                } else if (value is String) {
                  await SharedPreference.setString(key, value);
                  keyList.add(key);
                } else if (value is bool) {
                  await SharedPreference.setBool(key, value);
                  keyList.add(key);
                } else if (value is double) {
                  await SharedPreference.setDouble(key, value);
                  keyList.add(key);
                } else if (value is int) {
                  await SharedPreference.setInt(key, value);
                  keyList.add(key);
                } else {
                  if (kDebugMode) {
                    print("This data not restored: $key : ${value.toString()}");
                  }
                }
              }
            }
            onRestored.call(keyList);
          } else {
            scaffoldSnackbar
                .show(appLocalizations.restoring_data_failed_unsupported_file);
          }
        } catch (e) {
          if (kDebugMode) {
            print("Data Restore Error: $e");
          }
          scaffoldSnackbar.show(appLocalizations.an_error_occurred);
        }
      } else {
        scaffoldSnackbar.show(appLocalizations.restoring_data_cancelled);
      }
    } else {
      scaffoldSnackbar.show(appLocalizations.this_operation_is_not_supported);
    }
  }
}
