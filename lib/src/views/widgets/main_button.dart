import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    required this.onPressed,
    required this.child,
    this.textStyle,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;
    if (onPressed != null) {
      child = DefaultTextStyle(
        style: textStyle ?? context.textTheme.labelLarge ?? const TextStyle(),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: this.child,
        ),
      );
    }
    return Platform.isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            color: backgroundColor ?? context.colorScheme.primary,
            child: child,
            onPressed: onPressed,
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? context.colorScheme.primary,
            ),
            child: child,
            onPressed: onPressed,
          );
  }
}
