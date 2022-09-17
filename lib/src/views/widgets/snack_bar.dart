import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show3Sec({
    required BuildContext context,
    required String message,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
}
