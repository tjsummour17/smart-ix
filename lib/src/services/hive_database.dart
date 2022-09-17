import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_ix/src/models/user.dart';

class HiveDatabase {
  static const _langKey = 'langKey';
  static const _themeKey = 'themeKey';
  static const _userKey = 'userKey';

  static late Box<String> _langBox;
  static late Box<String> _themeBox;
  static late Box<User> _userBox;

  static Future<void> initializeDB() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(UserAdapter());
      _themeBox = await Hive.openBox<String>('theme');
      _langBox = await Hive.openBox<String>('lang');
      _userBox = await Hive.openBox<User>('user');
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  static void saveLastLoggedInUser(User user) {
    try {
      _userBox.put(_userKey, user);
    } catch (e) {
      log(e.toString());
    }
  }

  static User? getLastLoggedInUser() {
    try {
      return _userBox.get(_userKey);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static void deleteLastLoggedInUser() {
    try {
      _userBox.clear();
    } catch (e) {
      log(e.toString());
    }
  }

  static void saveLanguage(String lang) {
    try {
      _langBox.put(_langKey, lang);
    } catch (e) {
      log(e.toString());
    }
  }

  static String getLanguage() {
    try {
      return _langBox.get(_langKey) ?? 'en';
    } catch (e) {
      log(e.toString());
      return 'en';
    }
  }

  static void saveTheme(String name) {
    try {
      _themeBox.put(_themeKey, name);
    } catch (e) {
      log(e.toString());
    }
  }

  static String getTheme() {
    try {
      return _themeBox.get(_themeKey) ?? 'light';
    } catch (e) {
      log(e.toString());
      return 'light';
    }
  }

  @override
  String toString() => 'HiveDatabase';
}
