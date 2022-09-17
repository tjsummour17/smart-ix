import 'package:flutter/material.dart';
import 'package:smart_ix/src/services/hive_database.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';

class ThemeProvider with ChangeNotifier {
  static const String _lightThemeKey = 'light';
  static const String _darkThemeKey = 'dark';
  static const String _systemThemeKey = 'system';

  static ThemeMode themeFromName(String name) {
    if (name == _lightThemeKey) {
      return ThemeMode.light;
    } else if (name == _darkThemeKey) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  ThemeMode _themeMode = themeFromName(HiveDatabase.getTheme());

  void setThemeMode(ThemeMode? mode) {
    if (mode != null) {
      _themeMode = mode;
      notifyListeners();
      switch (mode) {
        case ThemeMode.light:
          HiveDatabase.saveTheme(_lightThemeKey);
          break;
        case ThemeMode.dark:
          HiveDatabase.saveTheme(_darkThemeKey);
          break;
        default:
          HiveDatabase.saveTheme(_systemThemeKey);
          break;
      }
    }
  }

  ThemeMode get themeMode => _themeMode;
}

extension ThemeModeX on ThemeMode {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return context.appLocalizations.system;
      case ThemeMode.dark:
        return context.appLocalizations.dark;
      case ThemeMode.light:
        return context.appLocalizations.light;
    }
  }
}
