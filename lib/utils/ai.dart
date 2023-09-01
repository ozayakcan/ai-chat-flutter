import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../secrets.dart';

class AI {
  final BuildContext context;

  AI._(this.context);

  factory AI.of(BuildContext context) {
    return AI._(context);
  }

  String _appUrl(String userid, String message) {
    return "http://api.brainshop.ai/get?bid=${Secrets.brainShopBrainID}&key=${Secrets.brainShopApiKey}&uid=$userid&msg=$message";
  }

  Future<String> sendMessage(String userid, String message) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    var dio = Dio();
    var response = await dio.get(_appUrl(userid, message),
        options: Options(contentType: "application/json; charset=UTF-8"));
    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');
    }
    if (response.statusCode == 200) {
      return response.data["cnt"];
    } else {
      return appLocalizations.an_error_occurred;
    }
  }
}
