import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/widgets/app_button.dart';

class CustomAlertDialogue extends StatelessWidget {
  const CustomAlertDialogue(
      {Key? key,
      required this.accountName,
      required this.decoderNumber,
      required this.bouquet,
      required this.amount,
      required this.onTap,
      this.type})
      : super(key: key);
  final String accountName;
  final String decoderNumber;
  final String bouquet;
  final String? type;
  final String amount;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 290,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 20, 20, 25),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body3L(
                    'Account Name',
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText.body1L(
                    accountName,
                    color: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AppText.body3L(
                    'Card Number',
                    color: kSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText.body1L(
                    decoderNumber,
                    color: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const DottedLine(
                    dashColor: kSecondaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AppText.body1L(
                    ' Details',
                    color: kSecondaryColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.body3L(
                        type!,
                        color: kSecondaryColor.withOpacity(0.5),
                      ),
                      AppText.body3L(
                        bouquet,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.body3L(
                        'Amount',
                        color: kSecondaryColor.withOpacity(0.5),
                      ),
                      AppText.body3L(
                        amount,
                        color: kSecondaryColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                title: 'PAY',
                onTap: onTap,
                //showBorder: true,
                backgroundColor: kSecondaryColor,
                textColor: kBlackColor,
                //width: 300,
                //borderRadius: 8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
