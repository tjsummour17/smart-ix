import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.backgroundColor = Colors.transparent})
      : super(key: key);
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Platform.isIOS
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
