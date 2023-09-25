import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    // required this.icon,
    this.hText,
    this.showSuffixIcon = false,
    this.icons = false,
    this.showPrefixIcon = false,
    this.validator,
    this.iconColor,
    this.otherText,
    this.enabled = true,
    this.onValueChanged,
    this.obscure = false,
    required this.maxLines,
    this.isPassword = false,
    required this.height,
    this.controller,
    this.keyboardType,
    this.labelText,
    this.headingText,
    this.inputFormatters = const [],
    this.prefix,
  }) : super(key: key);
  final String? hText;
  final String? otherText;
  final bool showSuffixIcon;
  final bool icons;
  final bool enabled;
  final Color? iconColor;
  final bool showPrefixIcon;
  final bool obscure;
  final int maxLines;
  final double height;
  final bool isPassword;
  final Function(String v)? onValueChanged;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? headingText;
  final Widget? prefix;

  final TextEditingController? controller;
  // final IconData icon;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType? keyboardType;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  // use to detect if user has input value
  bool _hasValue = false;
  bool _isObscured = true;
  Color headingTextColor = kSecondaryColor.withOpacity(0.46);
  changeHasValue(bool newHasValue) {
    setState(() {
      _hasValue = newHasValue;
    });
  }

  // bool hasFocus=
  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        headingTextColor = kSecondaryColor;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Row(children: [
         AppText.body4P(
          widget.headingText ?? "",
          color: headingTextColor,
          textAlign: TextAlign.left,
        ),
        Spacer(),
        AppText.body3L(widget.otherText??''),
       ],),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          cursorWidth: 1.5,
          cursorHeight: 17,
          cursorColor: kSecondaryColor,
          focusNode: _focusNode,
          controller: widget.controller,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          onChanged: (value) {
            if (_hasValue && value.isEmpty) {
              changeHasValue(false);
            } else if (!_hasValue && value.isNotEmpty) {
              changeHasValue(true);
            }
            if (widget.onValueChanged != null) {
              widget.onValueChanged!(value);
            }
          },
          obscureText: (widget.isPassword ? (_isObscured) : false),
          validator: widget.validator,
          style: body4PB,
          onFieldSubmitted: (v) {
            headingTextColor = kSecondaryColor.withOpacity(0.42);

            FocusScope.of(context).unfocus();
            setState(() {});
          },
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            prefix: widget.prefix,
            labelText: widget.labelText ?? "",
            labelStyle:
                body4P.copyWith(color: kSecondaryColor.withOpacity(0.5)),
            suffixIcon: !widget.isPassword
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: _toggle,
                    icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility),
                    color: Colors.white,
                  ),
            contentPadding: const EdgeInsets.only(left: 16),
            isDense: true,
            fillColor: Colors.transparent,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                width: 2,
                style: BorderStyle.solid,
                color: kSecondaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 1,
                color: kBorderColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                width: 1,
                color: kBorderColor,
              ),
            ),
            hintText: widget.hText ?? "",
            hintStyle: body1N,
          ),
        ),
      ],
    );
  }

  _toggle() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}
