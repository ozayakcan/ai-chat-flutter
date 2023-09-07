import 'package:flutter/material.dart';

import '../models/message.dart';
import '../utils/assets.dart';
import '../utils/shared_preferences.dart';
import '../utils/text.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.appName,
  });

  final String appName;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      NavigatorState navigator = Navigator.of(context);
      String? userID =
          await SharedPreference.getString(SharedPreference.userID);
      String realUserID = getRandomString(10);
      if (userID != null) {
        realUserID = userID;
      } else {
        await SharedPreference.setString(SharedPreference.userID, realUserID);
      }
      List<MessageModel> messages = await MessageModel.get();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                appName: widget.appName,
                userID: realUserID,
                messages: messages)),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.logo,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
