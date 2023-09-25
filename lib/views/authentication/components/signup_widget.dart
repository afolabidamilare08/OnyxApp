import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';

import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class SignupWidget extends StatelessWidget {
  const SignupWidget(
      {Key? key,
      required this.text,
      this.subText,
      required this.children,
      this.onBack})
      : super(key: key);
  final String text;
  final String? subText;
  final Widget children;
  final Function()? onBack;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          NyxIcons.arrow_back,
                          size: 18,
                          color: kSecondaryColor,
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: AppText.body7L(
                        text,
                        centered: true,
                        color: kSecondaryColor,
                        multitext: true,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    )
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                SizedBox(
                  child: AppText.body3L(
                    subText ?? '',
                    color: kSecondaryColor,
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 7.3) / 100,
                )
              ],
            ),
            children
          ],
        ),
      ],
    );
  }
}
