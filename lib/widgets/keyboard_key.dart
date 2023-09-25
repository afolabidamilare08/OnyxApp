
import 'package:flutter/material.dart';

import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class KeyboardKey extends StatefulWidget {
  const KeyboardKey(
      {Key? key, required this.label, this.value, required this.onTap})
      : super(key: key);
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;
  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  renderLabel() {
    if (widget.label is Widget) {
      return widget.label;
    }
    return AppText.body3L(
      widget.label,
      color: kSecondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.value);
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: kBorderColor),
                  right: BorderSide(color: kBorderColor),
                  bottom: BorderSide(color: kBorderColor))),
          child: renderLabel()),
    );
  }
}
