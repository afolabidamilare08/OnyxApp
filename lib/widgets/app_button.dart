import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';

import '../../utils/text.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color backgroundColor;
  final bool showBorder;
  final Color textColor;
  final Function()? onTap;
  final bool isDisabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const AppButton(
      {Key? key,
      required this.title,
      this.backgroundColor = kPrimaryColor,
      this.showBorder = false,
      this.textColor = Colors.white,
      this.onTap,
      this.height = 51,
      this.borderRadius,
      this.isDisabled = false,
      this.prefixIcon,
      this.suffixIcon,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isDisabled) {
          onTap?.call();
        }
      },
      child: Container(
        clipBehavior: Clip.none,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDisabled
              ? kPrimaryColor
              : showBorder
                  ? Colors.transparent
                  : width != null
                      ? kAccentColor
                      : backgroundColor,
          border: showBorder
              ? Border.all(
                  color: kBorderColor,
                  width: 1.0,
                  style: BorderStyle.solid,
                )
              : const Border.fromBorderSide(BorderSide.none),
          borderRadius:
              BorderRadius.circular(borderRadius == null ? 8 : borderRadius!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: prefixIcon != null,
              child: Icon(
                prefixIcon,
                size: 20,
                color: kSecondaryColor,
              ),
            ),
            const SizedBox(
              width: 11,
            ),
            width != null
                ? AppText.body1N(
                    title,
                    color: isDisabled ? kPrimaryColor : textColor,
                  )
                : AppText.button2N(
                    title,
                    color: isDisabled
                        ? kSecondaryColor.withOpacity(0.32)
                        : textColor,
                  ),
            const SizedBox(
              width: 11,
            ),
            Visibility(
              visible: suffixIcon != null,
              child: Icon(
                suffixIcon,
                size: 30,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
