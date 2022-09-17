import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_ix/src/utils/build_context_x.dart';
import 'package:smart_ix/src/views/widgets/main_button.dart';

class MainDropdownButton<M> extends StatefulWidget {
  const MainDropdownButton({
    required this.onSelectedItemChanged,
    required this.children,
    this.value,
    this.hintText,
    this.leading,
    this.trailing,
    Key? key,
  }) : super(key: key);
  final Function(int) onSelectedItemChanged;
  final List<MainDropdownItem<M>> children;
  final String? hintText;
  final M? value;
  final Widget? leading;
  final Widget? trailing;

  @override
  State<MainDropdownButton<M>> createState() => _MainDropdownButtonState<M>();
}

class _MainDropdownButtonState<M> extends State<MainDropdownButton<M>> {
  late Widget _cupertinoButtonText;

  @override
  void initState() {
    super.initState();
    assert(widget.value != null || widget.hintText != null);
    final hintText = widget.hintText;
    if (hintText != null) {
      _cupertinoButtonText = Text(hintText);
    } else {
      _cupertinoButtonText = Text(widget.value.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final leading = widget.leading;
    final trailing = widget.trailing;
    return Platform.isIOS
        ? MainButton(
            backgroundColor: context.colorScheme.surface,
            child: Row(
              children: [
                if (trailing != null) ...[
                  trailing,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: DefaultTextStyle(
                    style: widget.value != null
                        ? (context.textTheme.titleSmall ?? const TextStyle())
                        : ((_cupertinoButtonText is Text &&
                                    (_cupertinoButtonText as Text).data ==
                                        widget.hintText)
                                ? context.textTheme.caption
                                    ?.copyWith(fontSize: 16)
                                : context.textTheme.titleSmall) ??
                            const TextStyle(),
                    child: _cupertinoButtonText,
                  ),
                ),
                if (leading != null) leading,
              ],
            ),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => CupertinoActionSheet(
                message: SizedBox(
                  height: (widget.children.length * 35) + 30,
                  child: CupertinoPicker(
                    itemExtent: 30,
                    looping: false,
                    useMagnifier: true,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _cupertinoButtonText = widget.children[index].child;
                      });
                      widget.onSelectedItemChanged(index);
                    },
                    children: widget.children.map((e) => e.child).toList(),
                  ),
                ),
              ),
            ),
          )
        : DropdownButtonFormField<M>(
            borderRadius: BorderRadius.circular(20),
            decoration: InputDecoration(prefixIcon: trailing),
            hint: _cupertinoButtonText,
            items: [
              for (int i = 0; i < widget.children.length; i++)
                DropdownMenuItem(
                  child: widget.children[i].child,
                  value: widget.children[i].value,
                )
            ].toList(),
            onChanged: (M? value) {
              if (value != null) {
                int index = widget.children
                    .indexWhere((element) => element.value == value);
                setState(() {
                  widget.onSelectedItemChanged(index);
                  _cupertinoButtonText = widget.children[index].child;
                });
              }
            },
            icon: leading,
          );
  }
}

@immutable
class MainDropdownItem<M> {
  const MainDropdownItem({required this.child, required this.value});

  final Widget child;
  final M value;
}
