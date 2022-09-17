import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@immutable
class ModalActions {
  const ModalActions({
    required this.onPressed,
    required this.text,
    this.negativeAction = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool negativeAction;
}

class ModalBottomSheet extends StatelessWidget {
  const ModalBottomSheet({
    required this.actions,
    Key? key,
    this.title,
    this.showCloseButton = false,
  }) : super(key: key);

  final String? title;
  final List<ModalActions> actions;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    String? title = this.title;
    return Platform.isIOS
        ? CupertinoActionSheet(
            title: title != null ? Text(title) : null,
            cancelButton: showCloseButton
                ? CupertinoDialogAction(
                    onPressed: Navigator.of(context).pop,
                    child: Text(AppLocalizations.of(context)!.cancel),
                  )
                : null,
            actions: actions
                .map(
                  (action) => _buildCupertinoActionButton(
                    action: action,
                    context: context,
                  ),
                )
                .toList(),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (showCloseButton) const CloseButton(),
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        width: 100,
                        height: 5,
                      ),
                      if (showCloseButton) const SizedBox(width: 50)
                    ],
                  ),
                  if (title != null) ...[
                    const SizedBox(height: 7),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 7)
                  ],
                  for (ModalActions action in actions)
                    _buildMaterialActionButton(
                      action: action,
                      context: context,
                    ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          );
  }

  Widget _buildCupertinoActionButton({
    required BuildContext context,
    required ModalActions action,
  }) =>
      CupertinoDialogAction(
        onPressed: action.onPressed,
        isDestructiveAction: action.negativeAction,
        child: Text(action.text),
      );

  Widget _buildMaterialActionButton({
    required BuildContext context,
    required ModalActions action,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: action.negativeAction
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
          onPressed: action.onPressed,
          child: Text(action.text),
        ),
      );
}
