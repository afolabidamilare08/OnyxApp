import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      this.hintText,
      required this.color,
      required this.textColor,
      this.controller,
      this.onchanged,
      this.initialText,
      this.validator,
      this.cursorcolor = kPrimaryColor,
      this.keyboardtype})
      : super(key: key);
  final String? hintText;
  final String? initialText;
  final Color color;
  final Color textColor;
  final Color? cursorcolor;
  final TextEditingController? controller;
  final Function(String)? onchanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardtype;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //autofocus: true,
      //enabled: true,
      //focusNode: FocusNode(),
      style: body3L.copyWith(color: textColor),
      initialValue: initialText,
      controller: controller,
      validator: validator,
      // onFieldSubmitted: onchanged,
      keyboardType: keyboardtype,
      cursorColor: cursorcolor,
      decoration: InputDecoration(
        focusColor: kBorderColor,
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        hintText: hintText,
        hintStyle: body3L.copyWith(color: textColor),
      ),
    );
  }
}
