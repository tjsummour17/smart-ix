import 'package:flutter/material.dart';
import 'package:smart_ix/src/l10n/lang.dart';
import 'package:smart_ix/src/services/hive_database.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale(HiveDatabase.getLanguage());

  void setLocale(Locale? locale) {
    if (locale != null) {
      if (!Lang.all.contains(locale)) return;
      HiveDatabase.saveLanguage(locale.languageCode);
      _locale = locale;
      notifyListeners();
    }
  }

  Locale get locale => _locale;
}
