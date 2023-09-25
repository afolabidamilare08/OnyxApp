import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/widgets/app_text_field.dart';

import '../utils/color.dart';
import 'app_button.dart';

class TwoFactorBottomSheet extends StatelessWidget {
  const TwoFactorBottomSheet(
      {super.key,
      required this.onTap,
      required this.controller,
      required this.formKey});
  final Function()? onTap;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * 2) / 3,
      decoration: const BoxDecoration(
          color: kBlackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AppText.body1L(
                'Enter the code from your authenticator app',
                color: kSecondaryColor,
              ),
              SizedBox(
                height: 20,
              ),
              // AppText.body3L(
              //   'Google Authenticator Code',
              //   textAlign: TextAlign.left,
              // ),
              AppTextField(
                maxLines: 1,
                height: 51,

                //enabled: true,
                headingText: 'Google Authenticator Code',
                //hText: '123456',
                labelText: 'code',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the code';
                  } else if (value.length < 6 || value.length > 6) {
                    return 'Please enter a valid code';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                controller: controller,
              ),
              SizedBox(
                height: 20,
              ),
              AppButton(
                title: 'Continue',
                backgroundColor: kSecondaryColor,
                textColor: kPrimaryColor,
                onTap: onTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
