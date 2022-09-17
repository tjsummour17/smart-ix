import 'package:flutter/material.dart';

class Lang {
  static final all = [const Locale('en'), const Locale('ar')];

  static String getLangName(String code) {
    switch (code) {
      case 'ar':
        return '🇯🇴 عربي';
      case 'en':
      default:
        return 'English 🇺🇸';
    }
  }

  @override
  String toString() => 'Lang';
}
