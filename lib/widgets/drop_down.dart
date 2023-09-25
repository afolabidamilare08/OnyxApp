// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/text.dart';

class DropDown extends StatefulWidget {
  DropDown(
      {Key? key,
      required this.items,
      required this.text,
      this.dropDownColor,
      this.hint,
      required this.color})
      : super(key: key);
  List items;
  dynamic text;
  String? hint;
  Color color;
  Color? dropDownColor;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: AppText.body3L(widget.hint ?? ''),
        dropdownColor: widget.dropDownColor ?? kSecondaryColor,
        isExpanded: true,
        value: widget.hint ?? widget.text,
        onChanged: ((value) {
          setState(() {
            widget.text = value;
            print(widget.text);
          });
        }),
        items: widget.items.map((item) => buildMenuItem(item)).toList());
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem<String>(
      child: AppText.body3L(
        item,
        color: widget.color,
      ),
      value: item,
    );
  }
}
