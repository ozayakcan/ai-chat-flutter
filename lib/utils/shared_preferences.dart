import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const darkThemeString = "darkTheme";
  static const messagesString = "message";
  static const userID = "userID";

  static Future<bool> setString(String key, String value) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return await sharedPreferences.setString(key, value);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String?> getString(
    String key, {
    String? defaultValue,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getString(key) ?? defaultValue;
    } catch (e) {
      return Future.error(e);
    }
  }

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

  static Future<bool> setStringList(
    String key,
    List<String> value,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return await sharedPreferences.setStringList(key, value);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<String>> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      return sharedPreferences.getStringList(key) ?? defaultValue;
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
