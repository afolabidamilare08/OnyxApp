import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

class CableBottomSheet extends StatelessWidget {
  const CableBottomSheet(
      {super.key,
      required this.accountName,
      required this.decoderNumber,
      required this.bouquet,
      this.type,
      required this.amount,
      required this.onTap,
      required this.onTap2,
      required this.currentBouquet,
      required this.renewalAmount,
     });
  final String accountName;
  final String decoderNumber;
  final String bouquet;
  final String currentBouquet;
  final String? type;
  final String amount;
  final String renewalAmount;
  final Function() onTap;
  final Function() onTap2;

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
                  Row(children: [
                    AppText.body1L(
                      'Current Bouquet',
                      color: kSecondaryColor,
                    ),
                    Spacer(),
                    AppText.body1L(
                      'New Bouquet',
                      color: kSecondaryColor,
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.body3L(
                        bouquet,
                        color: kSecondaryColor,
                      ),
                      AppText.body3L(
                        currentBouquet,
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
                        renewalAmount,
                        color: kSecondaryColor,
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 51,
                        width: 150,
                        //width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kSecondaryColor),
                        child: Column(
                          children: [
                            AppText.body3L(
                              'Renew bouquet',
                              color: kPrimaryColor,
                            ),
                            AppText.body5L(
                              'N$renewalAmount',
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: onTap2,
                      child: Container(
                        height: 51,
                        width: 150,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kSecondaryColor),
                        child: Column(
                          children: [
                            AppText.body3L(
                              'New bouquet',
                              color: kPrimaryColor,
                            ),
                            AppText.body5L(
                              'N$amount',
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
    ;
  }
}
