// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';



class AccountDetailCard extends StatelessWidget {
  const AccountDetailCard(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap})
      : super(key: key);
  final IconData icon;
  final String title;
  final String subtitle;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: Color(0xff2b3b30),
          ),
          Container(
            decoration: BoxDecoration(color: AppColors.backgroundColor),
            padding:
                const EdgeInsets.only(top: 24, bottom: 32, left: 24, right: 24),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body4PB(title),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: AppText.body4L(subtitle))
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: kSecondaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
