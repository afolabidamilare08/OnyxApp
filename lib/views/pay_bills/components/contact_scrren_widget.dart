import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/utils/text.dart';

import '../../../utils/color.dart';

class ContactContainer extends StatelessWidget {
  const ContactContainer(
      {Key? key, required this.contactName, required this.mobileNumber})
      : super(key: key);
  final String contactName;
  final String mobileNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
                child: const Center(
                    child: Icon(
                  NyxIcons.account,
                  color: kSecondaryColor,
                )),
              ),
              const SizedBox(
                width: 10,
              ),
              AppText.button2L(
                contactName,
                color: kSecondaryColor,
              )
            ],
          ),
          AppText.body4L(
            mobileNumber,
            color: kSecondaryColor.withOpacity(0.4),
          )
        ],
      ),
    );
  }
}
