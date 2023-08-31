import 'package:flutter/material.dart';

import 'shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  late bool? _isDark;
  bool? get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    getPreferences();
  }
//Switching the themes
  set isDark(bool? value) {
    _isDark = value;
    if (value != null) {
      SharedPreference.setBool(SharedPreference.darkThemeString, value);
    } else {
      SharedPreference.remove(SharedPreference.darkThemeString);
    }
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await SharedPreference.getBool(SharedPreference.darkThemeString);
    notifyListeners();
  }

  static ThemeData get dark {
    Color buttonColor = const Color.fromARGB(255, 54, 54, 54);
    Color buttonHoverColor = const Color.fromARGB(255, 43, 42, 42);
    return ThemeData.dark(useMaterial3: true).copyWith(
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        splashColor: buttonHoverColor,
        hoverColor: buttonHoverColor,
        highlightColor: buttonHoverColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: buttonColor,
          background: buttonColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: buttonColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData.light(useMaterial3: true).copyWith(
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          background: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
  }
}
