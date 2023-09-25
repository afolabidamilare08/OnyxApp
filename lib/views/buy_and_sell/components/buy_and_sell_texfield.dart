import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class BuyAndSellTextField extends StatelessWidget {
  const BuyAndSellTextField(
      {Key? key,
      required this.headingText,
      required this.currAbbrv,
      required this.enableMax,
      this.otherText,
      required this.readonly,
      this.validator,
      required this.controller,
      this.maxPressed,
      this.onchanged})
      : super(key: key);
  final String headingText;
  final String currAbbrv;
  final String? otherText;
  final bool enableMax;
  final bool readonly;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String?)? onchanged;
  final Function()? maxPressed;
  @override
  Widget build(BuildContext context) {
    // String? formattedText =
    //     double.parse(otherText!.split(' ')[0]).toStringAsFixed(5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          AppText.body3L(
            headingText,
            textAlign: TextAlign.left,
            color: const Color(0xffd9d9d9),
          ),
          Spacer(),
          otherText == null ? SizedBox() : AppText.body4L('Balance:$otherText')
        ]),
        const SizedBox(
          height: 5,
        ),
        ClipRRect(
          // borderRadius: BorderRadius.circular(8),
          // clipBehavior: Clip.hardEdge,
          child: Container(
            height: 47,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xff2b3b30),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 15),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    readOnly: readonly,
                    onChanged: onchanged,
                    keyboardType: TextInputType.number,
                    cursorWidth: 1.5,
                    cursorHeight: 17,
                    cursorColor: kSecondaryColor,
                    style: body4PB,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                )),
                enableMax
                    ? IconButton(
                        onPressed: maxPressed,
                        icon: AppText.body3L(
                          "Max",
                          textAlign: TextAlign.left,
                          color: const Color(0xffd9d9d9),
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  color: kPrimaryColor,
                  height: 44,
                  width: 52,
                  child: Center(
                    child: AppText.heading2L(
                      currAbbrv.toUpperCase(),
                      color: currAbbrv.contains("ng") ||
                              currAbbrv.contains("NG")
                          ? const Color(0xff5Eb834)
                          : currAbbrv.contains("us") || currAbbrv.contains("US")
                              ? const Color(0xff42cfcf)
                              : const Color(0xffd6c533),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
