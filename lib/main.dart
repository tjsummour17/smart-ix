import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_ix/firebase_options.dart';
import 'package:smart_ix/src/services/hive_database.dart';
import 'package:smart_ix/src/views/widgets/application_material.dart';

void main() {
  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await HiveDatabase.initializeDB();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      log(e.toString());
    }
    FlutterError.onError = (FlutterErrorDetails details) {
      log(details.stack.toString());
      log(details.exception.toString());
    };
    runApp(const ApplicationMaterial());
  }, (error, stackTrace) {
    log(error.toString() + '\n\n' + stackTrace.toString());
  });
}
