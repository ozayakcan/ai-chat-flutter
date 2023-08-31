import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const darkThemeString = "darkTheme";

  static Future<bool> setBool(String key, bool value) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return await sharedPreferences.setBool(key, value);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<bool?> getBool(
    String key, {
    bool? defaultValue,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getBool(key) ?? defaultValue;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future remove(String key) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return await sharedPreferences.remove(key);
    } catch (e) {
      return Future.error(e);
    }
  }
}
